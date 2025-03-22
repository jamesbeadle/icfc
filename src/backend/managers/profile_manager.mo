import Base "mo:waterway-mops/BaseTypes";
import Text "mo:base/Text";
import T "../icfc_types";
import TrieMap "mo:base/TrieMap";
import List "mo:base/List";
import Result "mo:base/Result";
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import ProfileQueries "../queries/profile_queries";
import ProfileCommands "../commands/profile_commands";
import Utils "../utils/utils";
import Management "../utils/management";
import ProfileCanister "../canister_definations/profile-canister";
import Environment "../environment";
import Cycles "mo:base/ExperimentalCycles";
import Iter "mo:base/Iter";
import Time "mo:base/Time";
import SNSManager "sns_manager";
import SNSGovernance "../sns-wrappers/governance";

module {
    public class ProfileManager() {
        private var profileCanisterIndex : TrieMap.TrieMap<Base.PrincipalId, Base.CanisterId> = TrieMap.TrieMap<Base.PrincipalId, Base.CanisterId>(Text.equal, Text.hash);
        private var activeCanisterId : Base.CanisterId = "";
        private var usernames : TrieMap.TrieMap<Base.PrincipalId, Text> = TrieMap.TrieMap<Base.PrincipalId, Text>(Text.equal, Text.hash);
        private var uniqueProfileCanisterIds : List.List<Base.CanisterId> = List.nil();
        private var totalProfiles : Nat = 0;
        private var neuronsUsedforMembership : TrieMap.TrieMap<Blob, Base.PrincipalId> = TrieMap.TrieMap<Blob, Base.PrincipalId>(Blob.equal, Blob.hash);

        //Getters

        public func getProfilePicture(principalId : Base.PrincipalId) : async ?Blob {
            let existingProfileCanisterId = profileCanisterIndex.get(principalId);
            switch (existingProfileCanisterId) {
                case (?foundCanisterId) {

                    let profile_canister = actor (foundCanisterId) : actor {
                        getProfilePicture : (principalId : Base.PrincipalId) -> async ?Blob;
                    };

                    let profile = await profile_canister.getProfilePicture(principalId);
                    return profile;
                };
                case (null) {
                    return null;
                };
            };
        };

        public func getICFCMembership(caller : Base.PrincipalId, dto : ProfileCommands.GetICFCMembership) : async Result.Result<ProfileQueries.ICFCMembershipDTO, T.Error> {
            if (not callerAllowed(caller)) {
                return #err(#NotAllowed);
            };

            let existingProfileCanisterId = profileCanisterIndex.get(dto.principalId);
            switch (existingProfileCanisterId) {
                case (?foundCanisterId) {
                    let profile_canister = actor (foundCanisterId) : actor {
                        getICFCMembership : (dto : ProfileCommands.GetICFCMembership) -> async Result.Result<ProfileQueries.ICFCMembershipDTO, T.Error>;
                    };
                    return await profile_canister.getICFCMembership(dto);
                };
                case (null) {
                    return #err(#NotFound);
                };
            };
        };

        public func isUsernameAvailable(dto : ProfileQueries.IsUsernameAvailable) : ProfileQueries.UsernameAvailable {
            return not isUsernameTaken(dto.username, dto.principalId);
        };

        public func getProfile(dto : ProfileQueries.GetProfile) : async Result.Result<ProfileQueries.ProfileDTO, T.Error> {
            let existingProfileCanisterId = profileCanisterIndex.get(dto.principalId);
            switch (existingProfileCanisterId) {
                case (?foundCanisterId) {

                    let profile_canister = actor (foundCanisterId) : actor {
                        getProfile : (dto : ProfileQueries.GetProfile) -> async Result.Result<ProfileQueries.ProfileDTO, T.Error>;
                    };

                    let profile = await profile_canister.getProfile(dto);
                    return profile;
                };
                case (null) {
                    return #err(#NotFound);
                };
            };
        };

        // Update Functions
        public func createProfile(principalId : Base.PrincipalId, dto : ProfileCommands.CreateProfile) : async Result.Result<(), T.Error> {

            if (Text.size(dto.username) < 5 or Text.size(dto.username) > 20) {
                return #err(#TooLong);
            };

            let invalidUsername = isUsernameTaken(dto.username, principalId);
            if (invalidUsername) {
                return #err(#AlreadyExists);
            };

            let existingProfileCanisterId = profileCanisterIndex.get(principalId);
            switch (existingProfileCanisterId) {
                case (?_) {
                    return #err(#AlreadyExists);
                };
                case (null) {
                    if (activeCanisterId == "") {
                        await createNewCanister();
                    };

                    var profile_canister = actor (activeCanisterId) : actor {
                        isCanisterFull : () -> async Bool;
                        createProfile : (principalId : Base.PrincipalId, dto : ProfileCommands.CreateProfile) -> async Result.Result<(), T.Error>;
                    };

                    let isCanisterFull = await profile_canister.isCanisterFull();

                    if (isCanisterFull) {
                        await createNewCanister();
                        profile_canister := actor (activeCanisterId) : actor {
                            isCanisterFull : () -> async Bool;
                            createProfile : (principalId : Base.PrincipalId, dto : ProfileCommands.CreateProfile) -> async Result.Result<(), T.Error>;
                        };
                    };

                    profileCanisterIndex.put((principalId, activeCanisterId));
                    usernames.put(principalId, activeCanisterId);
                    return await profile_canister.createProfile(principalId, dto);
                };
            };
        };

        public func addSubApp(principalId : Base.PrincipalId, subAppRecord : ProfileCommands.AddSubApp) : async Result.Result<(), T.Error> {

            let existingProfileCanisterId = profileCanisterIndex.get(principalId);
            switch (existingProfileCanisterId) {
                case (?_) {
                    let dto : ProfileCommands.NotifyAppofLink = {
                        icfcPrincipalId = principalId;
                        subApp = subAppRecord.subApp;
                        subAppUserPrincipalId = subAppRecord.subAppUserPrincipalId;
                    };
                    let res = await notifyAppsofLink(dto);
                    return res;
                };
                case (null) {
                    return #err(#NotFound);
                };
            };
        };

        public func removeSubApp(principalId : Base.PrincipalId, subApp : T.SubApp) : async Result.Result<(), T.Error> {
            let existingProfileCanisterId = profileCanisterIndex.get(principalId);
            switch (existingProfileCanisterId) {
                case (?foundCanisterId) {
                    let profile_canister = actor (foundCanisterId) : actor {
                        removeSubApp : (dto : ProfileCommands.RemoveSubApp) -> async Result.Result<(), T.Error>;
                    };

                    let dtoRecord : ProfileCommands.RemoveSubApp = {
                        subApp = subApp;
                        userPrincipalId = principalId;
                    };
                    return await profile_canister.removeSubApp(dtoRecord);
                };
                case (null) {
                    return #err(#NotFound);
                };
            };
        };

        public func verifySubApp(caller : Base.PrincipalId, verifySubAppRecord : ProfileCommands.VerifySubApp) : async Result.Result<(), T.Error> {
            if (not callerAllowed(caller)) {
                return #err(#NotAllowed);
            };

            let existingProfileCanisterId = profileCanisterIndex.get(verifySubAppRecord.icfcPrincipalId);
            switch (existingProfileCanisterId) {
                case (?foundCanisterId) {
                    let profile_canister = actor (foundCanisterId) : actor {
                        updateAppPrincipalIds : (dto : ProfileCommands.AddSubApp) -> async Result.Result<(), T.Error>;
                    };
                    let res = await profile_canister.updateAppPrincipalIds({
                        subApp = verifySubAppRecord.subApp;
                        subAppUserPrincipalId = verifySubAppRecord.subAppUserPrincipalId;
                    });

                    return res;
                };
                case (null) {
                    return #err(#NotFound);
                };
            };

        };

        public func updateUsername(dto : ProfileCommands.UpdateUserName) : async Result.Result<(), T.Error> {
            if (Text.size(dto.username) < 5 or Text.size(dto.username) > 20) {
                return #err(#TooLong);
            };

            let lowerCaseNewUsername = Utils.toLowercase(dto.username);
            var currentOwner : ?Base.PrincipalId = findUsernamePrincipalId(lowerCaseNewUsername);

            switch (currentOwner) {
                case (?existingOwner) {
                    if (existingOwner == dto.principalId) {
                        return #ok;
                    };

                    var getCurrentOwnerProfileQuery : ProfileQueries.GetProfile = {
                        principalId = existingOwner;
                    };
                    let currentOwnerProfile = await getProfile(getCurrentOwnerProfileQuery);

                    var getRequesterProfileQuery : ProfileQueries.GetProfile = {
                        principalId = dto.principalId;
                    };
                    let requesterProfile = await getProfile(getRequesterProfileQuery);

                    switch (currentOwnerProfile, requesterProfile) {
                        case (#ok(currentProfile), #ok(requester)) {
                            let currentHasValidMembership = hasValidMembership(currentProfile);
                            let requesterHasValidMembership = hasValidMembership(requester);

                            if (not currentHasValidMembership and requesterHasValidMembership) {
                                let newRandomUsername = generateUniqueUsername(existingOwner);

                                // Update the current owner's username
                                let currentCanisterId = profileCanisterIndex.get(existingOwner);
                                switch (currentCanisterId) {
                                    case (?foundCanisterId) {
                                        let profile_canister = actor (foundCanisterId) : actor {
                                            updateUsername : (dto : ProfileCommands.UpdateUserName) -> async Result.Result<(), T.Error>;
                                        };

                                        let updateOldUser = await profile_canister.updateUsername({
                                            principalId = existingOwner;
                                            username = newRandomUsername;
                                        });

                                        if (updateOldUser != #ok) {
                                            return #err(#UpdateFailed);
                                        };

                                        usernames.put(existingOwner, newRandomUsername);
                                    };
                                    case (null) {
                                        return #err(#NotFound);
                                    };
                                };

                                // Allow the requester to claim the username
                                let requesterCanisterId = profileCanisterIndex.get(dto.principalId);
                                switch (requesterCanisterId) {
                                    case (?foundCanisterId) {
                                        let profile_canister = actor (foundCanisterId) : actor {
                                            updateUsername : (dto : ProfileCommands.UpdateUserName) -> async Result.Result<(), T.Error>;
                                        };

                                        let updateNewUser = await profile_canister.updateUsername(dto);
                                        if (updateNewUser == #ok) {
                                            usernames.put(dto.principalId, dto.username);
                                            return #ok;
                                        } else {
                                            return #err(#UpdateFailed);
                                        };
                                    };
                                    case (null) {
                                        return #err(#NotFound);
                                    };
                                };
                            } else {
                                return #err(#AlreadyClaimed);
                            };
                        };
                        case (_, _) {
                            return #err(#NotFound);
                        };
                    };
                };
                case (null) {
                    // Username is not taken, proceed with update
                    let existingProfileCanisterId = profileCanisterIndex.get(dto.principalId);
                    switch (existingProfileCanisterId) {
                        case (?foundCanisterId) {
                            let profile_canister = actor (foundCanisterId) : actor {
                                updateUsername : (dto : ProfileCommands.UpdateUserName) -> async Result.Result<(), T.Error>;
                            };

                            let updateResult = await profile_canister.updateUsername(dto);
                            if (updateResult == #ok) {
                                usernames.put(dto.principalId, dto.username);
                                return #ok;
                            } else {
                                return #err(#UpdateFailed);
                            };
                        };
                        case (null) {
                            return #err(#NotFound);
                        };
                    };
                };
            };
        };

        public func updateDisplayName(dto : ProfileCommands.UpdateDisplayName) : async Result.Result<(), T.Error> {

            if (Text.size(dto.displayName) < 1 or Text.size(dto.displayName) > 20) {
                return #err(#TooLong);
            };

            let existingProfileCanisterId = profileCanisterIndex.get(dto.principalId);
            switch (existingProfileCanisterId) {
                case (?foundCanisterId) {
                    let profile_canister = actor (foundCanisterId) : actor {
                        updateDisplayname : (dto : ProfileCommands.UpdateDisplayName) -> async Result.Result<(), T.Error>;
                    };
                    return await profile_canister.updateDisplayname(dto);
                };
                case (null) {
                    return #err(#NotFound);
                };
            };
        };

        public func updateProfilePicture(dto : ProfileCommands.UpdateProfilePicture) : async Result.Result<(), T.Error> {
            let validProfilePicture = isProfilePictureValid(dto.profilePicture);
            if (not validProfilePicture) {
                return #err(#InvalidProfilePicture);
            };

            let existingProfileCanisterId = profileCanisterIndex.get(dto.principalId);
            switch (existingProfileCanisterId) {
                case (?foundCanisterId) {
                    let profile_canister = actor (foundCanisterId) : actor {
                        updateProfilePicture : (dto : ProfileCommands.UpdateProfilePicture) -> async Result.Result<(), T.Error>;
                    };
                    return await profile_canister.updateProfilePicture(dto);
                };
                case (null) {
                    if (activeCanisterId == "") {
                        await createNewCanister();
                    };

                    var profile_canister = actor (activeCanisterId) : actor {
                        isCanisterFull : () -> async Bool;
                        updateProfilePicture : (dto : ProfileCommands.UpdateProfilePicture) -> async Result.Result<(), T.Error>;
                    };

                    let isCanisterFull = await profile_canister.isCanisterFull();
                    if (isCanisterFull) {
                        await createNewCanister();

                        profile_canister := actor (activeCanisterId) : actor {
                            updateProfilePicture : (dto : ProfileCommands.UpdateProfilePicture) -> async Result.Result<(), T.Error>;
                            isCanisterFull : () -> async Bool;
                        };
                    };

                    return await profile_canister.updateProfilePicture(dto);
                };
            };

            return #err(#NotFound);
        };

        public func claimMembership(dto : ProfileCommands.ClaimMembership) : async Result.Result<(T.MembershipClaim), T.Error> {
            let existingProfileCanisterId = profileCanisterIndex.get(dto.principalId);
            switch (existingProfileCanisterId) {
                case (?foundCanisterId) {
                    let profile_canister = actor (foundCanisterId) : actor {
                        getProfile : (dto : ProfileQueries.GetProfile) -> async Result.Result<ProfileQueries.ProfileDTO, T.Error>;
                    };

                    let profile = await profile_canister.getProfile(dto);
                    switch (profile) {
                        case (#ok(profileDTO)) {
                            let profile = profileDTO;
                            let currentMembership = profile.membershipType;

                            let snsManager = SNSManager.SNSManager();
                            let userNeurons : [SNSGovernance.Neuron] = await snsManager.getUsersNeurons(Principal.fromText(dto.principalId));
                            let eligibleMembership : T.EligibleMembership = Utils.getMembershipType(userNeurons);

                            let isNeuronsValid = validNeurons(eligibleMembership.eligibleNeuronIds, dto.principalId);
                            if (not isNeuronsValid) {
                                return #err(#NeuronAlreadyUsed);
                            };

                            switch (eligibleMembership.membershipType) {
                                case (newMembershipType) {
                                    if (newMembershipType == #NotEligible) {
                                        return #err(#InEligible);
                                    };

                                    let canUpgrade : Bool = Utils.canUpgradeMembership(currentMembership, newMembershipType);

                                    if (not canUpgrade) {
                                        switch (currentMembership) {
                                            case (#Monthly or #Seasonal) {
                                                let currentTimestamp = Time.now();
                                                let membershipClaim = List.last(List.fromArray(profile.membershipClaims));
                                                switch (membershipClaim) {
                                                    case (?claim) {
                                                        let expiresOn = claim.expiresOn;
                                                        switch (expiresOn) {
                                                            case (?exp) {
                                                                if (exp > currentTimestamp) {
                                                                    return #err(#AlreadyClaimed);
                                                                };
                                                            };
                                                            case (null) {};
                                                        };
                                                    };
                                                    case (null) {};
                                                };
                                            };
                                            case (_) {

                                                return #err(#AlreadyClaimed);
                                            };
                                        };
                                    };

                                    let updateMembershipCommand : ProfileCommands.UpdateMembership = {
                                        principalId = dto.principalId;
                                        membershipType = newMembershipType;
                                    };
                                    let res = await updateMembership(updateMembershipCommand);

                                    switch (res) {
                                        case (#ok(claim)) {
                                            let neuronsUsed : [Blob] = eligibleMembership.eligibleNeuronIds;
                                            for (neuronId in neuronsUsed.vals()) {
                                                neuronsUsedforMembership.put(neuronId, dto.principalId);
                                            };

                                            return #ok(claim);
                                        };
                                        case (#err(err)) {
                                            return #err(err);
                                        };
                                    };
                                };

                            };

                        };
                        case (#err(_)) {
                            return #err(#NotFound);
                        };
                    };
                };
                case (null) {
                    return #err(#NotFound);
                };
            };
        };

        public func updateMembership(dto : ProfileCommands.UpdateMembership) : async Result.Result<(T.MembershipClaim), T.Error> {
            let existingProfileCanisterId = profileCanisterIndex.get(dto.principalId);
            switch (existingProfileCanisterId) {
                case (?foundCanisterId) {
                    let profile_canister = actor (foundCanisterId) : actor {
                        updateMembership : (dto : ProfileCommands.UpdateMembership) -> async Result.Result<(T.MembershipClaim), T.Error>;
                    };
                    let res = await profile_canister.updateMembership(dto);
                    return res;
                };
                case (null) {
                    return #err(#NotFound);
                };
            };
        };

        // private functions
        private func callerAllowed(caller : Base.PrincipalId) : Bool {
            let allowed = [
                Environment.FOOTBALL_GOD_BACKEND_CANISTER_ID,
                Environment.OPENFPL_BACKEND_CANISTER_ID,
                Environment.OPENWSL_BACKEND_CANISTER_ID,
                Environment.JEFF_BETS_BACKEND_CANISTER_ID,
                Environment.TRANSFERKINGS_CANISTER_ID,
            ];
            for (principal in allowed.vals()) {
                if (principal == caller) {
                    return true;
                };
            };
            return false;
        };

        private func notifyAppsofLink(dto : ProfileCommands.NotifyAppofLink) : async Result.Result<(), T.Error> {
            switch (dto.subApp) {
                case (#OpenFPL) {
                    let openFPLCanister = actor (Environment.OPENFPL_BACKEND_CANISTER_ID) : actor {
                        notifyAppLink : (dto : ProfileCommands.NotifyAppofLink) -> async Result.Result<(), T.Error>;
                    };
                    return await openFPLCanister.notifyAppLink(dto);
                };
                case (#OpenWSL) {
                    let openWSLCanister = actor (Environment.OPENWSL_BACKEND_CANISTER_ID) : actor {
                        notifyAppLink : (dto : ProfileCommands.NotifyAppofLink) -> async Result.Result<(), T.Error>;
                    };
                    return await openWSLCanister.notifyAppLink(dto);
                };
                case (#JeffBets) {
                    let jeffBetsCanister = actor (Environment.JEFF_BETS_BACKEND_CANISTER_ID) : actor {
                        notifyAppLink : (dto : ProfileCommands.NotifyAppofLink) -> async Result.Result<(), T.Error>;
                    };
                    return await jeffBetsCanister.notifyAppLink(dto);
                };
                case (#TransferKings) {
                    let transferKingsCanister = actor (Environment.TRANSFERKINGS_CANISTER_ID) : actor {
                        notifyAppLink : (dto : ProfileCommands.NotifyAppofLink) -> async Result.Result<(), T.Error>;
                    };
                    return await transferKingsCanister.notifyAppLink(dto);
                };
                case (#FootballGod) {
                    let footballGodCanister = actor (Environment.FOOTBALL_GOD_BACKEND_CANISTER_ID) : actor {
                        notifyAppLink : (dto : ProfileCommands.NotifyAppofLink) -> async Result.Result<(), T.Error>;
                    };
                    return await footballGodCanister.notifyAppLink(dto);
                };
            };

        };

        public func isUsernameTaken(username : Text, principalId : Text) : Bool {
            for (managerUsername in usernames.entries()) {

                let lowerCaseUsername = Utils.toLowercase(username);
                let existingUsername = Utils.toLowercase(managerUsername.1);

                if (lowerCaseUsername == existingUsername and managerUsername.0 != principalId) {
                    return true;
                };
            };

            return false;
        };

        private func findUsernamePrincipalId(username : Text) : ?Base.PrincipalId {
            for (profileUsername in usernames.entries()) {
                let lowerCaseUsername = Utils.toLowercase(username);
                let existingUsername = Utils.toLowercase(profileUsername.1);

                if (lowerCaseUsername == existingUsername) {
                    return ?profileUsername.0;
                };
            };
            return null;
        };

        private func hasValidMembership(profile : T.Profile) : Bool {
            let membership = profile.membershipType;
            switch (membership) {
                case (#Founding) { return true };
                case (#Lifetime) { return true };
                case (#Seasonal) {
                    let currentTimestamp = Time.now();
                    let membershipClaim = List.last(List.fromArray(profile.membershipClaims));
                    switch (membershipClaim) {
                        case (?claim) {
                            let expiresOn = claim.expiresOn;
                            switch (expiresOn) {
                                case (?exp) { return exp > currentTimestamp };
                                case (null) { return true };
                            };
                        };
                        case (null) { return false };
                    };
                };
                case (#Monthly) {
                    let currentTimestamp = Time.now();
                    let membershipClaim = List.last(List.fromArray(profile.membershipClaims));
                    switch (membershipClaim) {
                        case (?claim) {
                            let expiresOn = claim.expiresOn;
                            switch (expiresOn) {
                                case (?exp) { return exp > currentTimestamp };
                                case (null) { return true };
                            };
                        };
                        case (null) { return false };
                    };
                };
                case (#Expired) { return false };
                case (#NotClaimed) { return false };
                case (#NotEligible) { return false };
            };
        };

        private func generateUniqueUsername(principalId : Base.PrincipalId) : Text {
            let randomSuffix = Text.toArray(principalId);
            var truncatedSuffix = "";
            for (i in Iter.range(0, 5)) {
                truncatedSuffix := truncatedSuffix # Text.fromChar(randomSuffix[i]);
            };
            return "user_" # truncatedSuffix;
        };

        private func isProfilePictureValid(profilePicture : ?Blob) : Bool {
            switch (profilePicture) {
                case (?foundProfilePicture) {
                    let sizeInKB = Array.size(Blob.toArray(foundProfilePicture)) / 1024;
                    return (sizeInKB > 0 or sizeInKB <= 500);
                };
                case (null) { return true };
            };
        };

        private func createNewCanister() : async () {

            Cycles.add<system>(50_000_000_000_000);
            let canister = await ProfileCanister._ProfileCanister();
            let canister_principal = Principal.fromActor(canister);
            let canisterId = Principal.toText(canister_principal);
            storeCanisterId(canisterId);
            activeCanisterId := canisterId;

            if (canisterId == "") {
                return;
            };

            let IC : Management.Management = actor (Environment.Default);
            let principal = ?Principal.fromText(Environment.BACKEND_CANISTER_ID);
            let _ = await Utils.updateCanister_(canister, principal, IC);
        };

        private func storeCanisterId(canisterId : Text) {
            let uniqueCanisterIdBuffer = Buffer.fromArray<Base.CanisterId>(List.toArray(uniqueProfileCanisterIds));
            uniqueCanisterIdBuffer.add(canisterId);
            uniqueProfileCanisterIds := List.fromArray(Buffer.toArray(uniqueCanisterIdBuffer));
        };

        private func validNeurons(neurons : [Blob], newPrinciaplId : Base.PrincipalId) : Bool {
            for (neuron in neurons.vals()) {
                let existingPrincipalId = neuronsUsedforMembership.get(neuron);
                switch (existingPrincipalId) {
                    case (?foundPrincipalId) {
                        if (foundPrincipalId != newPrinciaplId) {
                            return false;
                        };
                    };
                    case (null) {
                        return false;
                    };
                };
            };
            return true;
        };

        private func isProfileCanister(callerId : Base.PrincipalId) : Bool {
            for (canister in List.toArray(uniqueProfileCanisterIds).vals()) {
                if (canister == callerId) {
                    return true;
                };
            };
            return false;
        };

        // stable storage getters and setters
        public func getStableCanisterIndex() : [(Base.PrincipalId, Base.CanisterId)] {
            return Iter.toArray(profileCanisterIndex.entries());
        };

        public func setStableCanisterIndex(stable_profile_canister_index : [(Base.PrincipalId, Base.CanisterId)]) {
            let canisterIds : TrieMap.TrieMap<Base.PrincipalId, Base.CanisterId> = TrieMap.TrieMap<Base.PrincipalId, Base.CanisterId>(Text.equal, Text.hash);

            for (canisterId in Iter.fromArray(stable_profile_canister_index)) {
                canisterIds.put(canisterId);
            };
            profileCanisterIndex := canisterIds;
        };

        public func getStableActiveCanisterId() : Base.CanisterId {
            return activeCanisterId;
        };

        public func setStableActiveCanisterId(stable_active_canister_id : Base.CanisterId) {
            activeCanisterId := stable_active_canister_id;
        };

        public func getStableUsernames() : [(Base.PrincipalId, Text)] {
            return Iter.toArray(usernames.entries());
        };

        public func setStableUsernames(stable_usernames : [(Base.PrincipalId, Text)]) : () {
            let usernames_map : TrieMap.TrieMap<Base.PrincipalId, Base.CanisterId> = TrieMap.TrieMap<Base.PrincipalId, Base.CanisterId>(Text.equal, Text.hash);

            for (username in Iter.fromArray(stable_usernames)) {
                usernames_map.put(username);
            };
            usernames := usernames_map;
        };

        public func getStableUniqueCanisterIds() : [Base.CanisterId] {
            return List.toArray(uniqueProfileCanisterIds);
        };

        public func setStableUniqueCanisterIds(stable_unique_canister_ids : [Base.CanisterId]) : () {
            let canisterIdBuffer = Buffer.fromArray<Base.CanisterId>([]);

            for (canisterId in Iter.fromArray(stable_unique_canister_ids)) {
                canisterIdBuffer.add(canisterId);
            };
            uniqueProfileCanisterIds := List.fromArray(Buffer.toArray(canisterIdBuffer));
        };

        public func getStableTotalProfiles() : Nat {
            return totalProfiles;
        };

        public func setStableTotalProfiles(stable_total_profiles : Nat) : () {
            totalProfiles := stable_total_profiles;
        };

        public func getStableNeuronsUsedforMembership() : [(Blob, Base.PrincipalId)] {
            return Iter.toArray(neuronsUsedforMembership.entries());
        };

        public func setStableNeuronsUsedforMembership(stable_neurons_used_for_membership : [(Blob, Base.PrincipalId)]) : () {
            let neuronsUsedMap : TrieMap.TrieMap<Blob, Base.PrincipalId> = TrieMap.TrieMap<Blob, Base.PrincipalId>(Blob.equal, Blob.hash);

            for (neuron in Iter.fromArray(stable_neurons_used_for_membership)) {
                neuronsUsedMap.put(neuron);
            };
            neuronsUsedforMembership := neuronsUsedMap;
        };

        public shared ({ caller }) func removeNeuronsforExpiredMembership(principalId : Base.PrincipalId) : async () {
            assert not isProfileCanister(Principal.toText(caller));
            let existingProfileCanisterId = profileCanisterIndex.get(principalId);
            switch (existingProfileCanisterId) {
                case (?_) {
                    for (neuron in neuronsUsedforMembership.entries()) {
                        if (neuron.1 == principalId) {
                            neuronsUsedforMembership.delete(neuron.0);
                        };
                    };

                };
                case (null) {};
            };

        };
    };

};
