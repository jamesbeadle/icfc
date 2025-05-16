import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Buffer "mo:base/Buffer";
import Char "mo:base/Char";
import Cycles "mo:base/ExperimentalCycles";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Time "mo:base/Time";
import TrieMap "mo:base/TrieMap";

import CanisterIds "mo:waterway-mops/product/wwl/canister-ids";
import CanisterUtilities "mo:waterway-mops/product/wwl/canister-management/utilities";
import ConversionUtilities "mo:waterway-mops/base/utilities/conversion-utilities";
import Enums "mo:waterway-mops/base/enums";
import Ids "mo:waterway-mops/base/ids";
import Management "mo:waterway-mops/base/def/management";
import SNSGovernance "mo:waterway-mops/base/def/sns-wrappers/governance";

import ProfileQueries "../queries/profile-queries";
import ProfileCommands "../commands/profile-commands";
import ProfileCanister "../canister-definitions/profile-canister";
import SNSManager "sns-manager";
import T "../types";
import Utilities "../utilities/utilities";

module {
    public class ProfileManager() {
        private var profileCanisterIndex : TrieMap.TrieMap<Ids.PrincipalId, Ids.CanisterId> = TrieMap.TrieMap<Ids.PrincipalId, Ids.CanisterId>(Text.equal, Text.hash);
        private var activeCanisterId : Ids.CanisterId = "";
        private var usernames : TrieMap.TrieMap<Ids.PrincipalId, Text> = TrieMap.TrieMap<Ids.PrincipalId, Text>(Text.equal, Text.hash);
        private var uniqueProfileCanisterIds : List.List<Ids.CanisterId> = List.nil();
        private var totalProfiles : Nat = 0;
        private var neuronsUsedforMembership : TrieMap.TrieMap<Blob, Ids.PrincipalId> = TrieMap.TrieMap<Blob, Ids.PrincipalId>(Blob.equal, Blob.hash);

        //Getters
        public func getProfilePicture(principalId : Ids.PrincipalId) : async Result.Result<ProfileQueries.ProfilePictureDTO, Enums.Error> {
            let existingProfileCanisterId = profileCanisterIndex.get(principalId);
            switch (existingProfileCanisterId) {
                case (?foundCanisterId) {

                    let profile_canister = actor (foundCanisterId) : actor {
                        getProfile : (dto : ProfileQueries.GetProfile) -> async Result.Result<ProfileQueries.Profile, Enums.Error>;
                    };
                    let dto : ProfileQueries.GetProfile = {
                        principalId = principalId;
                    };
                    let profile = await profile_canister.getProfile(dto);

                    switch (profile) {
                        case (#ok(profileDTO)) {
                            return #ok({
                                profilePicture = profileDTO.profilePicture;
                            });
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

        public func getClaimedMembership(dto : ProfileQueries.GetClaimedMemberships) : async Result.Result<ProfileQueries.ClaimedMembershipsDTO, Enums.Error> {
            let existingProfileCanisterId = profileCanisterIndex.get(dto.principalId);
            switch (existingProfileCanisterId) {
                case (?foundCanisterId) {
                    let profile_canister = actor (foundCanisterId) : actor {
                        getClaimedMembership : (dto : ProfileQueries.GetClaimedMemberships) -> async Result.Result<ProfileQueries.ClaimedMembershipsDTO, Enums.Error>;
                    };
                    return await profile_canister.getClaimedMembership(dto);
                };
                case (null) {
                    return #err(#NotFound);
                };
            };
        };

        public func isUsernameAvailable(dto : ProfileQueries.IsUsernameAvailable) : ProfileQueries.UsernameAvailable {
            return not isUsernameTaken(dto.username, dto.principalId);
        };

        public func getProfile(dto : ProfileQueries.GetProfile) : async Result.Result<ProfileQueries.Profile, Enums.Error> {
            let existingProfileCanisterId = profileCanisterIndex.get(dto.principalId);
            switch (existingProfileCanisterId) {
                case (?foundCanisterId) {

                    let profile_canister = actor (foundCanisterId) : actor {
                        getProfile : (dto : ProfileQueries.GetProfile) -> async Result.Result<ProfileQueries.Profile, Enums.Error>;
                    };

                    let profile = await profile_canister.getProfile(dto);
                    return profile;
                };
                case (null) {
                    return #err(#NotFound);
                };
            };
        };

        public func getICFCProfileSummary(dto : ProfileCommands.GetICFCProfile) : async Result.Result<ProfileQueries.ICFCProfileSummary, Enums.Error> {
            let existingProfileCanisterId = profileCanisterIndex.get(dto.principalId);
            switch (existingProfileCanisterId) {
                case (?foundCanisterId) {

                    let profile_canister = actor (foundCanisterId) : actor {
                        getProfileSummary : (dto : ProfileCommands.GetICFCProfile) -> async Result.Result<ProfileQueries.ICFCProfileSummary, Enums.Error>;
                    };

                    let profile = await profile_canister.getProfileSummary(dto);
                    return profile;
                };
                case (null) {
                    return #err(#NotFound);
                };
            };
        };

        // Update Functions
        public func createProfile(principalId : Ids.PrincipalId, dto : ProfileCommands.CreateProfile, membership : T.EligibleMembership) : async Result.Result<(), Enums.Error> {

            if (Text.size(dto.username) < 5 or Text.size(dto.username) > 20) {
                return #err(#InvalidProperty);
            };

            let invalidUsername = isUsernameTaken(dto.username, principalId);
            if (invalidUsername) {
                return #err(#AlreadyExists);
            };

            if (membership.membershipType == #NotEligible) {
                return #err(#InEligible);
            };

            let isNeuronsValid = validNeurons(membership.eligibleNeuronIds, principalId);
            if (not isNeuronsValid) {
                return #err(#InEligible);
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
                        createProfile : (principalId : Ids.PrincipalId, dto : ProfileCommands.CreateProfile, membership : T.EligibleMembership) -> async Result.Result<(), Enums.Error>;
                    };

                    let isCanisterFull = await profile_canister.isCanisterFull();

                    if (isCanisterFull) {
                        await createNewCanister();
                        profile_canister := actor (activeCanisterId) : actor {
                            isCanisterFull : () -> async Bool;
                            createProfile : (principalId : Ids.PrincipalId, dto : ProfileCommands.CreateProfile, membership : T.EligibleMembership) -> async Result.Result<(), Enums.Error>;
                        };
                    };

                    let res = await profile_canister.createProfile(principalId, dto, membership);
                    switch (res) {
                        case (#ok(_)) {
                            profileCanisterIndex.put((principalId, activeCanisterId));
                            usernames.put(principalId, dto.username);
                            totalProfiles += 1;
                            for (neuron in membership.eligibleNeuronIds.vals()) {
                                neuronsUsedforMembership.put(neuron, principalId);
                            };
                            return #ok;
                        };

                        case (#err(err)) {
                            return #err(err);
                        };
                    }

                };
            };
        };

        public func addSubApp(principalId : Ids.PrincipalId, subAppRecord : ProfileCommands.AddSubApp) : async Result.Result<(), Enums.Error> {

            let existingProfileCanisterId = profileCanisterIndex.get(principalId);
            switch (existingProfileCanisterId) {
                case (?foundCanisterId) {
                    let getProfile : ProfileQueries.GetProfile = {
                        principalId = principalId;
                    };

                    let profile_canister = actor (foundCanisterId) : actor {
                        getProfile : (dto : ProfileQueries.GetProfile) -> async Result.Result<ProfileQueries.Profile, Enums.Error>;
                    };

                    let profile = await profile_canister.getProfile(getProfile);
                    switch (profile) {
                        case (#ok(profile)) {
                            let dto : ProfileCommands.NotifyAppofLink = {
                                icfcPrincipalId = principalId;
                                subApp = subAppRecord.subApp;
                                subAppUserPrincipalId = subAppRecord.subAppUserPrincipalId;
                                membershipType = profile.membershipType;
                            };
                            let res = await notifyAppsofLink(dto);
                            return res;
                        };
                        case (#err(err)) {
                            return #err(err);
                        };
                    };
                };
                case (null) {
                    return #err(#NotFound);
                };
            };
        };

        public func removeSubApp(principalId : Ids.PrincipalId, subApp : T.SubApp) : async Result.Result<(), Enums.Error> {
            let existingProfileCanisterId = profileCanisterIndex.get(principalId);
            switch (existingProfileCanisterId) {
                case (?foundCanisterId) {
                    let profile_canister = actor (foundCanisterId) : actor {
                        removeSubApp : (principalId : Ids.PrincipalId, dto : ProfileCommands.RemoveSubApp) -> async Result.Result<(), Enums.Error>;
                    };

                    let dtoRecord : ProfileCommands.RemoveSubApp = {
                        subApp = subApp;
                    };
                    let res = await profile_canister.removeSubApp(principalId, dtoRecord);
                    switch (res) {
                        case (#ok) {
                            let dto : ProfileCommands.NotifyAppofRemoveLink = {
                                icfcPrincipalId = principalId;
                                subApp = subApp;
                            };
                            let res = await notifyAppsofRemoveLink(dto);
                            return res;
                        };
                        case (#err(err)) {
                            return #err(err);
                        };
                    };
                };
                case (null) {
                    return #err(#NotFound);
                };
            };
        };

        public func verifySubApp(verifySubAppRecord : ProfileCommands.VerifySubApp) : async Result.Result<(), Enums.Error> {
            let existingProfileCanisterId = profileCanisterIndex.get(verifySubAppRecord.icfcPrincipalId);
            switch (existingProfileCanisterId) {
                case (?foundCanisterId) {
                    let profile_canister = actor (foundCanisterId) : actor {
                        updateAppPrincipalIds : (principalId : Ids.PrincipalId, dto : ProfileCommands.AddSubApp) -> async Result.Result<(), Enums.Error>;
                    };
                    let dto : ProfileCommands.AddSubApp = {

                        subApp = verifySubAppRecord.subApp;
                        subAppUserPrincipalId = verifySubAppRecord.subAppUserPrincipalId;
                    };
                    let res = await profile_canister.updateAppPrincipalIds(
                        verifySubAppRecord.icfcPrincipalId,
                        dto,
                    );

                    return res;
                };
                case (null) {
                    return #err(#NotFound);
                };
            };

        };

        public func updateUsername(principalId : Ids.PrincipalId, dto : ProfileCommands.UpdateUserName) : async Result.Result<(), Enums.Error> {
            if (Text.size(dto.username) < 5 or Text.size(dto.username) > 20) {
                return #err(#MaxDataExceeded);
            };

            let lowerCaseNewUsername = ConversionUtilities.toLowercase(dto.username);
            var existing_owner : ?Ids.PrincipalId = findUsernamePrincipalId(lowerCaseNewUsername);

            switch (existing_owner) {
                case (?_) {
                    return #err(#AlreadyClaimed);
                };
                case (null) {
                    let existingProfileCanisterId = profileCanisterIndex.get(principalId);
                    switch (existingProfileCanisterId) {
                        case (?foundCanisterId) {
                            let profile_canister = actor (foundCanisterId) : actor {
                                updateUsername : (principalId : Ids.PrincipalId, dto : ProfileCommands.UpdateUserName) -> async Result.Result<(), Enums.Error>;
                                getProfile : (dto : ProfileQueries.GetProfile) -> async Result.Result<ProfileQueries.Profile, Enums.Error>;
                            };

                            let updateResult = await profile_canister.updateUsername(principalId, dto);
                            if (updateResult == #ok) {
                                usernames.put(principalId, dto.username);

                                let profile = await profile_canister.getProfile({
                                    principalId = principalId;
                                });

                                switch (profile) {
                                    case (#ok(existingProfile)) {
                                        let profile : ProfileQueries.Profile = existingProfile;
                                        for ((subApp, subAppPrincipal) in profile.appPrincipalIds.vals()) {
                                            let _ = notifyAppsofProfileUpdate({
                                                membershipType = profile.membershipType;
                                                subApp = subApp;
                                                subAppUserPrincipalId = subAppPrincipal;
                                            });
                                        };
                                    };
                                    case (#err(err)) {
                                        return #err(err);
                                    };
                                };

                                return #ok;
                            } else {
                                return #err(#InvalidData);
                            };
                        };
                        case (null) {
                            return #err(#NotFound);
                        };
                    };
                };
            };
        };

        public func updateDisplayName(principalId : Ids.PrincipalId, dto : ProfileCommands.UpdateDisplayName) : async Result.Result<(), Enums.Error> {

            if (Text.size(dto.displayName) < 1 or Text.size(dto.displayName) > 20) {
                return #err(#MaxDataExceeded);
            };

            let existingProfileCanisterId = profileCanisterIndex.get(principalId);
            switch (existingProfileCanisterId) {
                case (?foundCanisterId) {
                    let profile_canister = actor (foundCanisterId) : actor {
                        updateDisplayName : (principalId : Ids.PrincipalId, dto : ProfileCommands.UpdateDisplayName) -> async Result.Result<(), Enums.Error>;
                        getProfile : (dto : ProfileQueries.GetProfile) -> async Result.Result<ProfileQueries.Profile, Enums.Error>;
                    };
                    let res = await profile_canister.updateDisplayName(principalId, dto);
                    switch (res) {
                        case (#ok) {
                            let profile = await profile_canister.getProfile({
                                principalId = principalId;
                            });

                            switch (profile) {
                                case (#ok(existingProfile)) {
                                    let profile : ProfileQueries.Profile = existingProfile;
                                    for ((subApp, subAppPrincipal) in profile.appPrincipalIds.vals()) {
                                        let _ = notifyAppsofProfileUpdate({
                                            membershipType = profile.membershipType;
                                            subApp = subApp;
                                            subAppUserPrincipalId = subAppPrincipal;
                                        });
                                    };
                                };
                                case (#err(err)) {
                                    return #err(err);
                                };
                            };

                            return #ok;
                        };
                        case (#err(err)) {
                            return #err(err);
                        };
                    };
                };
                case (null) {
                    return #err(#NotFound);
                };
            };
        };

        public func updateNationality(principalId : Ids.PrincipalId, dto : ProfileCommands.UpdateNationality) : async Result.Result<(), Enums.Error> {
            let existingProfileCanisterId = profileCanisterIndex.get(principalId);
            switch (existingProfileCanisterId) {
                case (?foundCanisterId) {
                    let profile_canister = actor (foundCanisterId) : actor {
                        updateNationality : (principalId : Ids.PrincipalId, dto : ProfileCommands.UpdateNationality) -> async Result.Result<(), Enums.Error>;
                    };
                    return await profile_canister.updateNationality(principalId, dto);
                };
                case (null) {
                    return #err(#NotFound);
                };
            };
        };

        public func updateFavouriteClub(principalId : Ids.PrincipalId, dto : ProfileCommands.UpdateFavouriteClub) : async Result.Result<(), Enums.Error> {
            let existingProfileCanisterId = profileCanisterIndex.get(principalId);
            switch (existingProfileCanisterId) {
                case (?foundCanisterId) {
                    let profile_canister = actor (foundCanisterId) : actor {
                        updateFavouriteClub : (principalId : Ids.PrincipalId, dto : ProfileCommands.UpdateFavouriteClub) -> async Result.Result<(), Enums.Error>;
                    };
                    return await profile_canister.updateFavouriteClub(principalId, dto);
                };
                case (null) {
                    return #err(#NotFound);
                };
            };
        };

        public func updateProfilePicture(principalId : Ids.PrincipalId, dto : ProfileCommands.UpdateProfilePicture) : async Result.Result<(), Enums.Error> {
            let validProfilePicture = isProfilePictureValid(dto.profilePicture);
            if (not validProfilePicture) {
                return #err(#InvalidData);
            };

            let existingProfileCanisterId = profileCanisterIndex.get(principalId);
            switch (existingProfileCanisterId) {
                case (?foundCanisterId) {
                    let profile_canister = actor (foundCanisterId) : actor {
                        updateProfilePicture : (principalId : Ids.PrincipalId, dto : ProfileCommands.UpdateProfilePicture) -> async Result.Result<(), Enums.Error>;
                        getProfile : (dto : ProfileQueries.GetProfile) -> async Result.Result<ProfileQueries.Profile, Enums.Error>;
                    };
                    let res = await profile_canister.updateProfilePicture(principalId, dto);
                    switch (res) {
                        case (#ok) {
                            let profile = await profile_canister.getProfile({
                                principalId = principalId;
                            });

                            switch (profile) {
                                case (#ok(existingProfile)) {
                                    let profile : ProfileQueries.Profile = existingProfile;
                                    for ((subApp, subAppPrincipal) in profile.appPrincipalIds.vals()) {
                                        let _ = notifyAppsofProfileUpdate({
                                            membershipType = profile.membershipType;
                                            subApp = subApp;
                                            subAppUserPrincipalId = subAppPrincipal;
                                        });
                                    };
                                };
                                case (#err(err)) {
                                    return #err(err);
                                };
                            };

                            return #ok;
                        };
                        case (#err(err)) {
                            return #err(err);
                        };
                    };
                };
                case (null) {
                    return #err(#NotFound);
                };
            };

            return #err(#NotFound);
        };

        public func claimMembership(principalId : Ids.PrincipalId) : async Result.Result<(T.MembershipClaim), Enums.Error> {
            let existingProfileCanisterId = profileCanisterIndex.get(principalId);
            switch (existingProfileCanisterId) {
                case (?foundCanisterId) {
                    let profile_canister = actor (foundCanisterId) : actor {
                        getProfile : (dto : ProfileQueries.GetProfile) -> async Result.Result<ProfileQueries.Profile, Enums.Error>;
                    };

                    let profile = await profile_canister.getProfile({
                        principalId;
                    });

                    switch (profile) {
                        case (#ok(profileDTO)) {
                            let profile = profileDTO;
                            let currentMembership = profile.membershipType;

                            let snsManager = SNSManager.SNSManager();
                            let userNeurons : [SNSGovernance.Neuron] = await snsManager.getUsersNeurons(Principal.fromText(principalId));
                            let eligibleMembership : T.EligibleMembership = Utilities.getMembershipType(userNeurons);

                            let isNeuronsValid = validNeurons(eligibleMembership.eligibleNeuronIds, principalId);
                            if (not isNeuronsValid) {
                                return #err(#InEligible);
                            };

                            switch (eligibleMembership.membershipType) {
                                case (newMembershipType) {
                                    if (newMembershipType == #NotEligible) {
                                        return #err(#NotAuthorized);
                                    };

                                    let canUpgrade : Bool = Utilities.canUpgradeMembership(currentMembership, newMembershipType);

                                    if (not canUpgrade) {
                                        switch (currentMembership) {
                                            case (#Monthly or #Seasonal or #Lifetime or #Founding) {
                                                let currentTimestamp = Time.now();

                                                let expiresOn = profile.membershipExpiryTime;

                                                if (expiresOn > currentTimestamp) {
                                                    return #err(#AlreadyExists);
                                                };

                                            };
                                            case (_) {
                                                return #err(#InEligible);
                                            };
                                        };
                                    };

                                    let updateMembershipCommand : ProfileCommands.UpdateMembership = {
                                        membershipType = newMembershipType;
                                    };
                                    let res = await updateMembership(principalId, updateMembershipCommand);

                                    switch (res) {
                                        case (#ok(claim)) {
                                            for (neuron in eligibleMembership.eligibleNeuronIds.vals()) {
                                                neuronsUsedforMembership.put(neuron, principalId);
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

        public func updateMembership(principalId : Ids.PrincipalId, dto : ProfileCommands.UpdateMembership) : async Result.Result<(T.MembershipClaim), Enums.Error> {
            let existingProfileCanisterId = profileCanisterIndex.get(principalId);
            switch (existingProfileCanisterId) {
                case (?foundCanisterId) {
                    let profile_canister = actor (foundCanisterId) : actor {
                        updateMembership : (principalId : Ids.PrincipalId, dto : ProfileCommands.UpdateMembership) -> async Result.Result<(T.MembershipClaim), Enums.Error>;
                        getProfile : (dto : ProfileQueries.GetProfile) -> async Result.Result<ProfileQueries.Profile, Enums.Error>;
                    };
                    let res = await profile_canister.updateMembership(principalId, dto);

                    switch (res) {
                        case (#ok(claim)) {
                            let profile = await profile_canister.getProfile({
                                principalId = principalId;
                            });

                            switch (profile) {
                                case (#ok(existingProfile)) {
                                    let profile : ProfileQueries.Profile = existingProfile;
                                    for ((subApp, subAppPrincipal) in profile.appPrincipalIds.vals()) {
                                        let _ = notifyAppsofProfileUpdate({
                                            membershipType = profile.membershipType;
                                            subApp = subApp;
                                            subAppUserPrincipalId = subAppPrincipal;
                                        });
                                    };
                                };
                                case (#err(err)) {
                                    return #err(err);
                                };
                            };

                            return #ok(claim);
                        };
                        case (#err(err)) {
                            return #err(err);
                        };
                    };
                };
                case (null) {
                    return #err(#NotFound);
                };
            };
        };

        // private functions
        private func notifyAppsofLink(dto : ProfileCommands.NotifyAppofLink) : async Result.Result<(), Enums.Error> {
            switch (dto.subApp) {
                case (#OpenFPL) {
                    let openFPLCanister = actor (CanisterIds.OPENFPL_BACKEND_CANISTER_ID) : actor {
                        notifyAppLink : (dto : ProfileCommands.NotifyAppofLink) -> async Result.Result<(), Enums.Error>;
                    };
                    return await openFPLCanister.notifyAppLink(dto);
                };
                case (#OpenWSL) {
                    let openWSLCanister = actor (CanisterIds.OPENWSL_BACKEND_CANISTER_ID) : actor {
                        notifyAppLink : (dto : ProfileCommands.NotifyAppofLink) -> async Result.Result<(), Enums.Error>;
                    };
                    return await openWSLCanister.notifyAppLink(dto);
                };
                case (#JeffBets) {
                    let jeffBetsCanister = actor (CanisterIds.JEFF_BETS_BACKEND_CANISTER_ID) : actor {
                        notifyAppLink : (dto : ProfileCommands.NotifyAppofLink) -> async Result.Result<(), Enums.Error>;
                    };
                    return await jeffBetsCanister.notifyAppLink(dto);
                };
                case (#TransferKings) {
                    let transferKingsCanister = actor (CanisterIds.TRANSFER_KINGS_BACKEND_CANISTER_ID) : actor {
                        notifyAppLink : (dto : ProfileCommands.NotifyAppofLink) -> async Result.Result<(), Enums.Error>;
                    };
                    return await transferKingsCanister.notifyAppLink(dto);
                };
                case (#FootballGod) {
                    let footballGodCanister = actor (CanisterIds.FOOTBALL_GOD_BACKEND_CANISTER_ID) : actor {
                        notifyAppLink : (dto : ProfileCommands.NotifyAppofLink) -> async Result.Result<(), Enums.Error>;
                    };
                    return await footballGodCanister.notifyAppLink(dto);
                };
            };

        };
        private func notifyAppsofRemoveLink(dto : ProfileCommands.NotifyAppofRemoveLink) : async Result.Result<(), Enums.Error> {
            switch (dto.subApp) {
                case (#OpenFPL) {
                    let openFPLCanister = actor (CanisterIds.OPENFPL_BACKEND_CANISTER_ID) : actor {
                        notifyAppRemoveLink : (dto : ProfileCommands.NotifyAppofRemoveLink) -> async Result.Result<(), Enums.Error>;
                    };
                    return await openFPLCanister.notifyAppRemoveLink(dto);
                };
                case (#OpenWSL) {
                    let openWSLCanister = actor (CanisterIds.OPENWSL_BACKEND_CANISTER_ID) : actor {
                        notifyAppRemoveLink : (dto : ProfileCommands.NotifyAppofRemoveLink) -> async Result.Result<(), Enums.Error>;
                    };
                    return await openWSLCanister.notifyAppRemoveLink(dto);
                };
                case (#JeffBets) {
                    let jeffBetsCanister = actor (CanisterIds.JEFF_BETS_BACKEND_CANISTER_ID) : actor {
                        notifyAppRemoveLink : (dto : ProfileCommands.NotifyAppofRemoveLink) -> async Result.Result<(), Enums.Error>;
                    };
                    return await jeffBetsCanister.notifyAppRemoveLink(dto);
                };
                case (#TransferKings) {
                    let transferKingsCanister = actor (CanisterIds.TRANSFER_KINGS_BACKEND_CANISTER_ID) : actor {
                        notifyAppRemoveLink : (dto : ProfileCommands.NotifyAppofRemoveLink) -> async Result.Result<(), Enums.Error>;
                    };
                    return await transferKingsCanister.notifyAppRemoveLink(dto);
                };
                case (#FootballGod) {
                    let footballGodCanister = actor (CanisterIds.FOOTBALL_GOD_BACKEND_CANISTER_ID) : actor {
                        notifyAppRemoveLink : (dto : ProfileCommands.NotifyAppofRemoveLink) -> async Result.Result<(), Enums.Error>;
                    };
                    return await footballGodCanister.notifyAppRemoveLink(dto);
                };
            };

        };
        private func notifyAppsofProfileUpdate(dto : ProfileCommands.UpdateICFCProfile) : async Result.Result<(), Enums.Error> {
            switch (dto.subApp) {
                case (#OpenFPL) {
                    let openFPLCanister = actor (CanisterIds.OPENFPL_BACKEND_CANISTER_ID) : actor {
                        noitifyAppofICFCHashUpdate(dto : ProfileCommands.UpdateICFCProfile) : async Result.Result<(), Enums.Error>;
                    };
                    return await openFPLCanister.noitifyAppofICFCHashUpdate(dto);
                };
                case (#OpenWSL) {
                    let openWSLCanister = actor (CanisterIds.OPENWSL_BACKEND_CANISTER_ID) : actor {
                        noitifyAppofICFCHashUpdate(dto : ProfileCommands.UpdateICFCProfile) : async Result.Result<(), Enums.Error>;
                    };
                    return await openWSLCanister.noitifyAppofICFCHashUpdate(dto);
                };
                case (#JeffBets) {
                    let jeffBetsCanister = actor (CanisterIds.JEFF_BETS_BACKEND_CANISTER_ID) : actor {
                        noitifyAppofICFCHashUpdate(dto : ProfileCommands.UpdateICFCProfile) : async Result.Result<(), Enums.Error>;
                    };
                    return await jeffBetsCanister.noitifyAppofICFCHashUpdate(dto);
                };
                case (#TransferKings) {
                    let transferKingsCanister = actor (CanisterIds.TRANSFER_KINGS_BACKEND_CANISTER_ID) : actor {
                        noitifyAppofICFCHashUpdate(dto : ProfileCommands.UpdateICFCProfile) : async Result.Result<(), Enums.Error>;
                    };
                    return await transferKingsCanister.noitifyAppofICFCHashUpdate(dto);
                };
                case (#FootballGod) {
                    let footballGodCanister = actor (CanisterIds.FOOTBALL_GOD_BACKEND_CANISTER_ID) : actor {
                        noitifyAppofICFCHashUpdate(dto : ProfileCommands.UpdateICFCProfile) : async Result.Result<(), Enums.Error>;
                    };
                    return await footballGodCanister.noitifyAppofICFCHashUpdate(dto);
                };
            };

        };

        public func toLowercase(t : Text.Text) : Text.Text {
            func charToLower(c : Char) : Char {
                if (Char.isUppercase(c)) {
                    Char.fromNat32(Char.toNat32(c) + 32);
                } else {
                    c;
                };
            };
            Text.map(t, charToLower);
        };

        public func isUsernameTaken(username : Text, principalId : Text) : Bool {
            for (managerUsername in usernames.entries()) {

                let lowerCaseUsername = toLowercase(username);
                let existingUsername = toLowercase(managerUsername.1);

                if (lowerCaseUsername == existingUsername and managerUsername.0 != principalId) {
                    return true;
                };
            };

            return false;
        };

        private func findUsernamePrincipalId(username : Text) : ?Ids.PrincipalId {
            for (profileUsername in usernames.entries()) {
                let lowerCaseUsername = toLowercase(username);
                let existingUsername = toLowercase(profileUsername.1);

                if (lowerCaseUsername == existingUsername) {
                    return ?profileUsername.0;
                };
            };
            return null;
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

        // TODO deal with deprecated cycles usage

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

            let IC : Management.Management = actor (CanisterIds.Default);
            let principal = ?Principal.fromText(CanisterIds.ICFC_BACKEND_CANISTER_ID);
            let _ = await CanisterUtilities.updateCanister_(canister, principal, IC);
        };

        private func storeCanisterId(canisterId : Text) {
            let uniqueCanisterIdBuffer = Buffer.fromArray<Ids.CanisterId>(List.toArray(uniqueProfileCanisterIds));
            uniqueCanisterIdBuffer.add(canisterId);
            uniqueProfileCanisterIds := List.fromArray(Buffer.toArray(uniqueCanisterIdBuffer));
        };

        public func validNeurons(neurons : [Blob], newPrinciaplId : Ids.PrincipalId) : Bool {
            for (neuron in neurons.vals()) {
                let existingPrincipalId = neuronsUsedforMembership.get(neuron);
                switch (existingPrincipalId) {
                    case (?foundPrincipalId) {
                        if (foundPrincipalId != newPrinciaplId) {
                            return false;
                        };
                    };
                    case (null) {};
                };
            };
            return true;
        };

        public func isProfileCanister(callerId : Ids.PrincipalId) : Bool {
            for (canister in List.toArray(uniqueProfileCanisterIds).vals()) {
                if (canister == callerId) {
                    return true;
                };
            };
            return false;
        };

        // stable storage getters and setters
        public func getStableCanisterIndex() : [(Ids.PrincipalId, Ids.CanisterId)] {
            return Iter.toArray(profileCanisterIndex.entries());
        };

        public func setStableCanisterIndex(stable_profile_canister_index : [(Ids.PrincipalId, Ids.CanisterId)]) {
            let canisterIds : TrieMap.TrieMap<Ids.PrincipalId, Ids.CanisterId> = TrieMap.TrieMap<Ids.PrincipalId, Ids.CanisterId>(Text.equal, Text.hash);

            for (canisterId in Iter.fromArray(stable_profile_canister_index)) {
                canisterIds.put(canisterId);
            };
            profileCanisterIndex := canisterIds;
        };

        public func getStableActiveCanisterId() : Ids.CanisterId {
            return activeCanisterId;
        };

        public func setStableActiveCanisterId(stable_active_canister_id : Ids.CanisterId) {
            activeCanisterId := stable_active_canister_id;
        };

        public func getStableUsernames() : [(Ids.PrincipalId, Text)] {
            return Iter.toArray(usernames.entries());
        };

        public func setStableUsernames(stable_usernames : [(Ids.PrincipalId, Text)]) : () {
            let usernames_map : TrieMap.TrieMap<Ids.PrincipalId, Text> = TrieMap.TrieMap<Ids.PrincipalId, Text>(Text.equal, Text.hash);

            for (username in Iter.fromArray(stable_usernames)) {
                usernames_map.put(username);
            };
            usernames := usernames_map;
        };

        public func getStableUniqueCanisterIds() : [Ids.CanisterId] {
            return List.toArray(uniqueProfileCanisterIds);
        };

        public func setStableUniqueCanisterIds(stable_unique_canister_ids : [Ids.CanisterId]) : () {
            let canisterIdBuffer = Buffer.fromArray<Ids.CanisterId>([]);

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

        public func getStableNeuronsUsedforMembership() : [(Blob, Ids.PrincipalId)] {
            return Iter.toArray(neuronsUsedforMembership.entries());
        };

        public func setStableNeuronsUsedforMembership(stable_neurons_used_for_membership : [(Blob, Ids.PrincipalId)]) : () {
            let neuronsUsedMap : TrieMap.TrieMap<Blob, Ids.PrincipalId> = TrieMap.TrieMap<Blob, Ids.PrincipalId>(Blob.equal, Blob.hash);

            for (neuron in Iter.fromArray(stable_neurons_used_for_membership)) {
                neuronsUsedMap.put(neuron);
            };
            neuronsUsedforMembership := neuronsUsedMap;
        };

        public func removeNeuronsforExpiredMembership(principalId : Ids.PrincipalId) : async () {
            let existingProfileCanisterId = profileCanisterIndex.get(principalId);
            switch (existingProfileCanisterId) {
                case (?_) {
                    for (neuron in neuronsUsedforMembership.entries()) {
                        if (neuron.1 == principalId) {
                            neuronsUsedforMembership.delete(neuron.0);
                        };
                    };

                    let _ = await claimMembership(principalId);

                };
                case (null) {};
            };

        };

        public func checkMemberships() : async () {
            for (canisterId in List.toArray(uniqueProfileCanisterIds).vals()) {
                let profile_canister = actor (canisterId) : actor {
                    checkAndExpireMembership : () -> async ();
                };
                await profile_canister.checkAndExpireMembership();
            };
        };
    };

};
