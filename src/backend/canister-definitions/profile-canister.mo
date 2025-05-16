import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Result "mo:base/Result";
import Principal "mo:base/Principal";
import Time "mo:base/Time";

import CanisterCommands "mo:waterway-mops/product/wwl/canister-management/commands";
import CanisterIds "mo:waterway-mops/product/wwl/canister-ids";
import CanisterManager "mo:waterway-mops/product/wwl/canister-management/manager";
import Enums "mo:waterway-mops/base/enums";
import Ids "mo:waterway-mops/base/ids";

import ProfileQueries "../queries/profile-queries";
import ProfileCommands "../commands/profile-commands";
import T "../types";
import Utilities "../utilities/utilities";

actor class _ProfileCanister() {
    let canisterManager = CanisterManager.CanisterManager();

    private stable var stable_profile_group_indexes : [(Ids.PrincipalId, Nat8)] = [];
    private stable var profileGroup1 : [T.Profile] = [];
    private stable var profileGroup2 : [T.Profile] = [];
    private stable var profileGroup3 : [T.Profile] = [];
    private stable var profileGroup4 : [T.Profile] = [];
    private stable var profileGroup5 : [T.Profile] = [];
    private stable var profileGroup6 : [T.Profile] = [];
    private stable var profileGroup7 : [T.Profile] = [];
    private stable var profileGroup8 : [T.Profile] = [];
    private stable var profileGroup9 : [T.Profile] = [];
    private stable var profileGroup10 : [T.Profile] = [];
    private stable var profileGroup11 : [T.Profile] = [];
    private stable var profileGroup12 : [T.Profile] = [];

    private stable var activeGroupIndex : Nat8 = 0;
    private stable var totalProfiles = 0;
    private stable var MAX_PROFILES_PER_GROUP : Nat = 1000;
    private stable var MAX_PROFILES_PER_CANISTER : Nat = 12000;
    private stable var canisterFull = false;

    private let MEMBERSHIPS_ROW_COUNT_LIMIT = 20;

    //Public endpoints

    public shared ({ caller }) func getProfile(dto : ProfileQueries.GetProfile) : async Result.Result<ProfileQueries.Profile, Enums.Error> {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == CanisterIds.ICFC_BACKEND_CANISTER_ID;

        var groupIndex : ?Nat8 = null;
        for (profileGroupIndex in Iter.fromArray(stable_profile_group_indexes)) {
            if (profileGroupIndex.0 == dto.principalId) {
                groupIndex := ?profileGroupIndex.1;
            };
        };
        switch (groupIndex) {
            case (null) { return #err(#NotFound) };
            case (?foundGroupIndex) {
                let profile = findProfile(foundGroupIndex, dto.principalId);
                switch (profile) {
                    case (?foundProfile) {

                        let recent_5_membership_claims = List.take<T.MembershipClaim>(List.reverse(List.fromArray(foundProfile.membershipClaims)), 5);
                        let membershipArray = List.toArray(recent_5_membership_claims);

                        let dto : ProfileQueries.Profile = {
                            principalId = foundProfile.principalId;
                            username = foundProfile.username;
                            profilePicture = foundProfile.profilePicture;
                            displayName = foundProfile.displayName;
                            termsAgreed = foundProfile.termsAgreed;
                            appPrincipalIds = foundProfile.appPrincipalIds;
                            subscribedChannelIds = foundProfile.subscribedChannelIds;
                            membershipType = foundProfile.membershipType;
                            membershipClaims = membershipArray;
                            createdOn = foundProfile.createdOn;
                            membershipExpiryTime = foundProfile.membershipExpiryTime;
                            favouriteLeagueId = foundProfile.favouriteLeagueId;
                            favouriteClubId = foundProfile.favouriteClubId;
                            nationalityId = foundProfile.nationalityId;
                        };
                        return #ok(dto);
                    };
                    case (null) {
                        return #err(#NotFound);
                    };
                };
            };
        };
    };

    public shared ({ caller }) func getProfileSummary(dto : ProfileQueries.GetProfile) : async Result.Result<ProfileQueries.ICFCProfileSummary, Enums.Error> {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == CanisterIds.ICFC_BACKEND_CANISTER_ID;

        var groupIndex : ?Nat8 = null;
        for (profileGroupIndex in Iter.fromArray(stable_profile_group_indexes)) {
            if (profileGroupIndex.0 == dto.principalId) {
                groupIndex := ?profileGroupIndex.1;
            };
        };
        switch (groupIndex) {
            case (null) { return #err(#NotFound) };
            case (?foundGroupIndex) {
                let profile = findProfile(foundGroupIndex, dto.principalId);
                switch (profile) {
                    case (?foundProfile) {
                        let dto : ProfileQueries.ICFCProfileSummary = {
                            principalId = foundProfile.principalId;
                            username = foundProfile.username;
                            profilePicture = foundProfile.profilePicture;
                            displayName = foundProfile.displayName;
                            termsAgreed = foundProfile.termsAgreed;
                            membershipType = foundProfile.membershipType;
                            createdOn = foundProfile.createdOn;
                            membershipExpiryTime = foundProfile.membershipExpiryTime;
                            favouriteLeagueId = foundProfile.favouriteLeagueId;
                            favouriteClubId = foundProfile.favouriteClubId;
                            nationalityId = foundProfile.nationalityId;
                            membershipClaims = foundProfile.membershipClaims;
                        };
                        return #ok(dto);
                    };
                    case (null) {
                        return #err(#NotFound);
                    };
                };
            };
        };
    };

    public shared ({ caller }) func getClaimedMembership(dto : ProfileQueries.GetClaimedMemberships) : async Result.Result<ProfileQueries.ClaimedMembershipsDTO, Enums.Error> {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == CanisterIds.ICFC_BACKEND_CANISTER_ID;

        var groupIndex : ?Nat8 = null;
        for (profileGroupIndex in Iter.fromArray(stable_profile_group_indexes)) {
            if (profileGroupIndex.0 == dto.principalId) {
                groupIndex := ?profileGroupIndex.1;
            };
        };
        switch (groupIndex) {
            case (null) { return #err(#NotFound) };
            case (?foundGroupIndex) {
                let profile = findProfile(foundGroupIndex, dto.principalId);
                switch (profile) {
                    case (?foundProfile) {
                        let allMembershipClaims = List.fromArray(foundProfile.membershipClaims);
                        let droppedEntries = List.drop<T.MembershipClaim>(allMembershipClaims, dto.offset);
                        let paginatedEntires = List.take<T.MembershipClaim>(droppedEntries, MEMBERSHIPS_ROW_COUNT_LIMIT);

                        let claimedMembershipsDTO : ProfileQueries.ClaimedMembershipsDTO = {
                            claimedMemberships = List.toArray(paginatedEntires);
                        };
                        return #ok(claimedMembershipsDTO);
                    };
                    case (null) {
                        return #err(#NotFound);
                    };
                };
            };
        };
    };

    public shared ({ caller }) func createProfile(profilePrincipalId : Ids.PrincipalId, dto : ProfileCommands.CreateProfile, membership : T.EligibleMembership) : async Result.Result<(), Enums.Error> {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == CanisterIds.ICFC_BACKEND_CANISTER_ID;

        if (totalProfiles >= MAX_PROFILES_PER_CANISTER) {
            return #err(#MaxDataExceeded);
        };

        if (getProfileCountInGroup(activeGroupIndex) >= MAX_PROFILES_PER_GROUP) {
            activeGroupIndex += 1;
        };

        if (activeGroupIndex > 11) {
            canisterFull := true;
            return #err(#MaxDataExceeded);
        };

        let newProfile : T.Profile = {
            principalId = profilePrincipalId;
            profilePicture = dto.profilePicture;
            username = dto.username;
            displayName = dto.displayName;
            termsAgreed = false;
            appPrincipalIds = [];
            subscribedChannelIds = [];
            membershipType = membership.membershipType;
            membershipClaims = [{
                purchasedOn = Time.now();
                expiresOn = ?Utilities.getMembershipExpirationDate(membership.membershipType);
                membershipType = membership.membershipType;
            }];
            createdOn = Time.now();
            membershipExpiryTime = Utilities.getMembershipExpirationDate(membership.membershipType);
            favouriteLeagueId = dto.favouriteLeagueId;
            favouriteClubId = dto.favouriteClubId;
            nationalityId = dto.nationalityId;
        };

        let _ = addProfile(newProfile);

        return #ok();

    };

    public shared ({ caller }) func updateUsername(principalId : Ids.PrincipalId, dto : ProfileCommands.UpdateUserName) : async Result.Result<(), Enums.Error> {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == CanisterIds.ICFC_BACKEND_CANISTER_ID;

        var groupIndex : ?Nat8 = null;
        for (profileGroupIndex in Iter.fromArray(stable_profile_group_indexes)) {
            if (profileGroupIndex.0 == principalId) {
                groupIndex := ?profileGroupIndex.1;
            };
        };
        switch (groupIndex) {
            case (null) { return #err(#NotFound) };
            case (?foundGroupIndex) {
                let profile = findProfile(foundGroupIndex, principalId);
                switch (profile) {
                    case (?foundProfile) {
                        let updatedProfile : T.Profile = {
                            principalId = foundProfile.principalId;
                            username = dto.username;
                            displayName = foundProfile.displayName;
                            membershipType = foundProfile.membershipType;
                            membershipClaims = foundProfile.membershipClaims;
                            createdOn = foundProfile.createdOn;
                            profilePicture = foundProfile.profilePicture;
                            termsAgreed = foundProfile.termsAgreed;
                            appPrincipalIds = foundProfile.appPrincipalIds;
                            subscribedChannelIds = foundProfile.subscribedChannelIds;
                            membershipExpiryTime = foundProfile.membershipExpiryTime;
                            favouriteLeagueId = foundProfile.favouriteLeagueId;
                            favouriteClubId = foundProfile.favouriteClubId;
                            nationalityId = foundProfile.nationalityId;
                        };
                        await saveProfile(foundGroupIndex, updatedProfile);
                    };
                    case (null) {
                        return #err(#NotFound);
                    };
                };
            };
        };
    };

    public shared ({ caller }) func updateDisplayName(principalId : Ids.PrincipalId, dto : ProfileCommands.UpdateDisplayName) : async Result.Result<(), Enums.Error> {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == CanisterIds.ICFC_BACKEND_CANISTER_ID;

        var groupIndex : ?Nat8 = null;
        for (profileGroupIndex in Iter.fromArray(stable_profile_group_indexes)) {
            if (profileGroupIndex.0 == principalId) {
                groupIndex := ?profileGroupIndex.1;
            };
        };
        switch (groupIndex) {
            case (null) { return #err(#NotFound) };
            case (?foundGroupIndex) {
                let profile = findProfile(foundGroupIndex, principalId);
                switch (profile) {
                    case (?foundProfile) {
                        let updatedProfile : T.Profile = {
                            principalId = foundProfile.principalId;
                            username = foundProfile.username;
                            displayName = dto.displayName;
                            membershipType = foundProfile.membershipType;
                            membershipClaims = foundProfile.membershipClaims;
                            createdOn = foundProfile.createdOn;
                            profilePicture = foundProfile.profilePicture;
                            termsAgreed = foundProfile.termsAgreed;
                            appPrincipalIds = foundProfile.appPrincipalIds;
                            subscribedChannelIds = foundProfile.subscribedChannelIds;
                            membershipExpiryTime = foundProfile.membershipExpiryTime;
                            favouriteLeagueId = foundProfile.favouriteLeagueId;
                            favouriteClubId = foundProfile.favouriteClubId;
                            nationalityId = foundProfile.nationalityId;
                        };
                        await saveProfile(foundGroupIndex, updatedProfile);
                    };
                    case (null) {
                        return #err(#NotFound);
                    };
                };
            };
        };
    };

    public shared ({ caller }) func updateNationality(principalId : Ids.PrincipalId, dto : ProfileCommands.UpdateNationality) : async Result.Result<(), Enums.Error> {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == CanisterIds.ICFC_BACKEND_CANISTER_ID;

        var groupIndex : ?Nat8 = null;
        for (profileGroupIndex in Iter.fromArray(stable_profile_group_indexes)) {
            if (profileGroupIndex.0 == principalId) {
                groupIndex := ?profileGroupIndex.1;
            };
        };
        switch (groupIndex) {
            case (null) { return #err(#NotFound) };
            case (?foundGroupIndex) {
                let profile = findProfile(foundGroupIndex, principalId);
                switch (profile) {
                    case (?foundProfile) {
                        let updatedProfile : T.Profile = {
                            principalId = foundProfile.principalId;
                            username = foundProfile.username;
                            displayName = foundProfile.displayName;
                            membershipType = foundProfile.membershipType;
                            membershipClaims = foundProfile.membershipClaims;
                            createdOn = foundProfile.createdOn;
                            profilePicture = foundProfile.profilePicture;
                            termsAgreed = foundProfile.termsAgreed;
                            appPrincipalIds = foundProfile.appPrincipalIds;
                            subscribedChannelIds = foundProfile.subscribedChannelIds;
                            membershipExpiryTime = foundProfile.membershipExpiryTime;
                            favouriteLeagueId = foundProfile.favouriteLeagueId;
                            favouriteClubId = foundProfile.favouriteClubId;
                            nationalityId = ?dto.nationalityId;
                        };
                        await saveProfile(foundGroupIndex, updatedProfile);
                    };
                    case (null) {
                        return #err(#NotFound);
                    };
                };
            };
        };
    };

    public shared ({ caller }) func updateFavouriteClub(principalId : Ids.PrincipalId, dto : ProfileCommands.UpdateFavouriteClub) : async Result.Result<(), Enums.Error> {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == CanisterIds.ICFC_BACKEND_CANISTER_ID;

        var groupIndex : ?Nat8 = null;
        for (profileGroupIndex in Iter.fromArray(stable_profile_group_indexes)) {
            if (profileGroupIndex.0 == principalId) {
                groupIndex := ?profileGroupIndex.1;
            };
        };
        switch (groupIndex) {
            case (null) { return #err(#NotFound) };
            case (?foundGroupIndex) {
                let profile = findProfile(foundGroupIndex, principalId);
                switch (profile) {
                    case (?foundProfile) {
                        let updatedProfile : T.Profile = {
                            principalId = foundProfile.principalId;
                            username = foundProfile.username;
                            displayName = foundProfile.displayName;
                            membershipType = foundProfile.membershipType;
                            membershipClaims = foundProfile.membershipClaims;
                            createdOn = foundProfile.createdOn;
                            profilePicture = foundProfile.profilePicture;
                            termsAgreed = foundProfile.termsAgreed;
                            appPrincipalIds = foundProfile.appPrincipalIds;
                            subscribedChannelIds = foundProfile.subscribedChannelIds;
                            membershipExpiryTime = foundProfile.membershipExpiryTime;
                            favouriteLeagueId = ?dto.favouriteLeagueId;
                            favouriteClubId = ?dto.favouriteClubId;
                            nationalityId = foundProfile.nationalityId;
                        };
                        await saveProfile(foundGroupIndex, updatedProfile);
                    };
                    case (null) {
                        return #err(#NotFound);
                    };
                };
            };
        };
    };

    public shared ({ caller }) func updateAppPrincipalIds(principalId : Ids.PrincipalId, dto : ProfileCommands.AddSubApp) : async Result.Result<(), Enums.Error> {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == CanisterIds.ICFC_BACKEND_CANISTER_ID;

        var groupIndex : ?Nat8 = null;
        for (profileGroupIndex in Iter.fromArray(stable_profile_group_indexes)) {
            if (profileGroupIndex.0 == principalId) {
                groupIndex := ?profileGroupIndex.1;
            };
        };
        switch (groupIndex) {
            case (null) { return #err(#NotFound) };
            case (?foundGroupIndex) {
                let profile = findProfile(foundGroupIndex, principalId);
                switch (profile) {
                    case (?foundProfile) {

                        var appPrincipalIdsBuffer = Buffer.fromArray<(T.SubApp, Ids.PrincipalId)>(foundProfile.appPrincipalIds);

                        let subAppAlreadyLinked = Array.find<(T.SubApp, Ids.PrincipalId)>(
                            foundProfile.appPrincipalIds,
                            func(appPrincipalId : (T.SubApp, Ids.PrincipalId)) {
                                appPrincipalId.0 == dto.subApp;
                            },
                        );

                        // add new subapp if not already linked
                        if (subAppAlreadyLinked == null) {
                            appPrincipalIdsBuffer.add((dto.subApp, dto.subAppUserPrincipalId));
                        } else {
                            // update subapp if already linked
                            // let updatedAppPrincipalIds = Array.map<(T.SubApp, Ids.PrincipalId), (T.SubApp, Ids.PrincipalId)>(
                            //     foundProfile.appPrincipalIds,
                            //     func(appPrincipalId : (T.SubApp, Ids.PrincipalId)) {
                            //         if (appPrincipalId.0 == dto.subApp) {
                            //             (appPrincipalId.0, dto.subAppUserPrincipalId);
                            //         } else {
                            //             appPrincipalId;
                            //         };
                            //     },
                            // );

                            // appPrincipalIdsBuffer := Buffer.fromArray<(T.SubApp, Ids.PrincipalId)>(updatedAppPrincipalIds);

                            return #err(#AlreadyExists);

                        };

                        let updatedProfile : T.Profile = {
                            principalId = foundProfile.principalId;
                            username = foundProfile.username;
                            displayName = foundProfile.displayName;
                            membershipType = foundProfile.membershipType;
                            membershipClaims = foundProfile.membershipClaims;
                            createdOn = foundProfile.createdOn;
                            profilePicture = foundProfile.profilePicture;
                            termsAgreed = foundProfile.termsAgreed;
                            appPrincipalIds = Buffer.toArray(appPrincipalIdsBuffer);
                            subscribedChannelIds = foundProfile.subscribedChannelIds;
                            membershipExpiryTime = foundProfile.membershipExpiryTime;
                            favouriteLeagueId = foundProfile.favouriteLeagueId;
                            favouriteClubId = foundProfile.favouriteClubId;
                            nationalityId = foundProfile.nationalityId;
                        };
                        await saveProfile(foundGroupIndex, updatedProfile);
                    };
                    case (null) {
                        return #err(#NotFound);
                    };
                };
            };
        };
    };

    public shared ({ caller }) func removeSubApp(principalId : Ids.PrincipalId, dto : ProfileCommands.RemoveSubApp) : async Result.Result<(), Enums.Error> {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == CanisterIds.ICFC_BACKEND_CANISTER_ID;

        var groupIndex : ?Nat8 = null;
        for (profileGroupIndex in Iter.fromArray(stable_profile_group_indexes)) {
            if (profileGroupIndex.0 == principalId) {
                groupIndex := ?profileGroupIndex.1;
            };
        };

        switch (groupIndex) {
            case (null) { return #err(#NotFound) };
            case (?foundGroupIndex) {
                let profile = findProfile(foundGroupIndex, principalId);
                switch (profile) {
                    case (?foundProfile) {
                        let updatedAppPrincipalIds = Array.filter<(T.SubApp, Ids.PrincipalId)>(
                            foundProfile.appPrincipalIds,
                            func(appPrincipalId : (T.SubApp, Ids.PrincipalId)) {
                                appPrincipalId.0 != dto.subApp;
                            },
                        );

                        let updatedProfile : T.Profile = {
                            principalId = foundProfile.principalId;
                            username = foundProfile.username;
                            displayName = foundProfile.displayName;
                            membershipType = foundProfile.membershipType;
                            membershipClaims = foundProfile.membershipClaims;
                            createdOn = foundProfile.createdOn;
                            profilePicture = foundProfile.profilePicture;
                            termsAgreed = foundProfile.termsAgreed;
                            appPrincipalIds = updatedAppPrincipalIds;
                            subscribedChannelIds = foundProfile.subscribedChannelIds;
                            membershipExpiryTime = foundProfile.membershipExpiryTime;
                            favouriteLeagueId = foundProfile.favouriteLeagueId;
                            favouriteClubId = foundProfile.favouriteClubId;
                            nationalityId = foundProfile.nationalityId;
                        };
                        await saveProfile(foundGroupIndex, updatedProfile);
                    };
                    case (null) {
                        return #err(#NotFound);
                    };
                };
            };
        };
    };

    public shared ({ caller }) func updateProfilePicture(principalId : Ids.PrincipalId, dto : ProfileCommands.UpdateProfilePicture) : async Result.Result<(), Enums.Error> {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == CanisterIds.ICFC_BACKEND_CANISTER_ID;

        var groupIndex : ?Nat8 = null;
        for (profileGroupIndex in Iter.fromArray(stable_profile_group_indexes)) {
            if (profileGroupIndex.0 == principalId) {
                groupIndex := ?profileGroupIndex.1;
            };
        };
        switch (groupIndex) {
            case (null) { return #err(#NotFound) };
            case (?foundGroupIndex) {
                let profile = findProfile(foundGroupIndex, principalId);
                switch (profile) {
                    case (?foundProfile) {
                        let updatedProfile : T.Profile = {
                            principalId = foundProfile.principalId;
                            username = foundProfile.username;
                            displayName = foundProfile.displayName;
                            membershipType = foundProfile.membershipType;
                            membershipClaims = foundProfile.membershipClaims;
                            createdOn = foundProfile.createdOn;
                            profilePicture = dto.profilePicture;
                            termsAgreed = foundProfile.termsAgreed;
                            appPrincipalIds = foundProfile.appPrincipalIds;
                            subscribedChannelIds = foundProfile.subscribedChannelIds;
                            membershipExpiryTime = foundProfile.membershipExpiryTime;
                            favouriteLeagueId = foundProfile.favouriteLeagueId;
                            favouriteClubId = foundProfile.favouriteClubId;
                            nationalityId = foundProfile.nationalityId;
                        };
                        await saveProfile(foundGroupIndex, updatedProfile);
                    };
                    case (null) {
                        return #err(#NotFound);
                    };
                };
            };
        };
    };

    public shared ({ caller }) func updateMembership(principalId : Ids.PrincipalId, dto : ProfileCommands.UpdateMembership) : async Result.Result<(T.MembershipClaim), Enums.Error> {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == CanisterIds.ICFC_BACKEND_CANISTER_ID;

        var groupIndex : ?Nat8 = null;
        for (profileGroupIndex in Iter.fromArray(stable_profile_group_indexes)) {
            if (profileGroupIndex.0 == principalId) {
                groupIndex := ?profileGroupIndex.1;
            };
        };

        switch (groupIndex) {
            case (null) { return #err(#NotFound) };
            case (?foundGroupIndex) {
                let profile = findProfile(foundGroupIndex, principalId);
                switch (profile) {
                    case (?foundProfile) {
                        let membershipClaimsBuffer = Buffer.fromArray<T.MembershipClaim>(foundProfile.membershipClaims);
                        let newClaim : T.MembershipClaim = {
                            membershipType = dto.membershipType;
                            purchasedOn = Time.now();
                            expiresOn = ?Utilities.getMembershipExpirationDate(dto.membershipType);
                        };
                        membershipClaimsBuffer.add(newClaim);
                        let updatedMembershipClaims = Buffer.toArray(membershipClaimsBuffer);

                        let updatedProfile : T.Profile = {
                            principalId = foundProfile.principalId;
                            username = foundProfile.username;
                            displayName = foundProfile.displayName;
                            membershipType = dto.membershipType;
                            membershipClaims = updatedMembershipClaims;
                            createdOn = foundProfile.createdOn;
                            profilePicture = foundProfile.profilePicture;
                            termsAgreed = foundProfile.termsAgreed;
                            appPrincipalIds = foundProfile.appPrincipalIds;
                            subscribedChannelIds = foundProfile.subscribedChannelIds;
                            membershipExpiryTime = switch (newClaim.expiresOn) {
                                case (?expiryTime) {
                                    expiryTime;
                                };
                                case (null) {
                                    0;
                                };
                            };
                            favouriteLeagueId = foundProfile.favouriteLeagueId;
                            favouriteClubId = foundProfile.favouriteClubId;
                            nationalityId = foundProfile.nationalityId;
                        };

                        let res = await saveProfile(foundGroupIndex, updatedProfile);
                        switch (res) {
                            case (#err(error)) { return #err(error) };
                            case (#ok) { return #ok(newClaim) };
                        };

                    };
                    case (null) {
                        return #err(#NotFound);
                    };
                };
            };
        };
    };

    public shared ({ caller }) func isCanisterFull() : async Bool {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == CanisterIds.ICFC_BACKEND_CANISTER_ID;
        return (totalProfiles >= MAX_PROFILES_PER_CANISTER);
    };

    public shared ({ caller }) func checkAndExpireMembership() : async () {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == CanisterIds.ICFC_BACKEND_CANISTER_ID;

        for (index in Iter.range(0, 11)) {
            switch (index) {
                case 0 {
                    for (profile in Iter.fromArray(profileGroup1)) {
                        if (profile.membershipExpiryTime < Time.now()) {
                            let _ = expireMembership(profile.principalId);
                        };
                    };
                };
                case 1 {
                    for (profile in Iter.fromArray(profileGroup2)) {
                        if (profile.membershipExpiryTime < Time.now()) {
                            let _ = expireMembership(profile.principalId);
                        };
                    };
                };
                case 2 {
                    for (profile in Iter.fromArray(profileGroup3)) {
                        if (profile.membershipExpiryTime < Time.now()) {
                            let _ = expireMembership(profile.principalId);
                        };
                    };
                };
                case 3 {
                    for (profile in Iter.fromArray(profileGroup4)) {
                        if (profile.membershipExpiryTime < Time.now()) {
                            let _ = expireMembership(profile.principalId);
                        };
                    };
                };
                case 4 {
                    for (profile in Iter.fromArray(profileGroup5)) {
                        if (profile.membershipExpiryTime < Time.now()) {
                            let _ = expireMembership(profile.principalId);
                        };
                    };
                };
                case 5 {
                    for (profile in Iter.fromArray(profileGroup6)) {
                        if (profile.membershipExpiryTime < Time.now()) {
                            let _ = expireMembership(profile.principalId);
                        };
                    };
                };
                case 6 {
                    for (profile in Iter.fromArray(profileGroup7)) {
                        if (profile.membershipExpiryTime < Time.now()) {
                            let _ = expireMembership(profile.principalId);
                        };
                    };
                };
                case 7 {
                    for (profile in Iter.fromArray(profileGroup8)) {
                        if (profile.membershipExpiryTime < Time.now()) {
                            let _ = expireMembership(profile.principalId);
                        };
                    };
                };
                case 8 {
                    for (profile in Iter.fromArray(profileGroup9)) {
                        if (profile.membershipExpiryTime < Time.now()) {
                            let _ = expireMembership(profile.principalId);
                        };
                    };
                };
                case 9 {
                    for (profile in Iter.fromArray(profileGroup10)) {
                        if (profile.membershipExpiryTime < Time.now()) {
                            let _ = expireMembership(profile.principalId);
                        };
                    };
                };
                case 10 {
                    for (profile in Iter.fromArray(profileGroup11)) {
                        if (profile.membershipExpiryTime < Time.now()) {
                            let _ = expireMembership(profile.principalId);
                        };
                    };
                };
                case 11 {
                    for (profile in Iter.fromArray(profileGroup12)) {
                        if (profile.membershipExpiryTime < Time.now()) {
                            let _ = expireMembership(profile.principalId);
                        };
                    };
                };
                case _ {};
            };
        };
    };

    private func expireMembership(principalId : Ids.PrincipalId) : async () {

        var groupIndex : ?Nat8 = null;
        for (profileGroupIndex in Iter.fromArray(stable_profile_group_indexes)) {
            if (profileGroupIndex.0 == principalId) {
                groupIndex := ?profileGroupIndex.1;
            };
        };

        switch (groupIndex) {
            case (null) { return };
            case (?foundGroupIndex) {
                let profile = findProfile(foundGroupIndex, principalId);
                switch (profile) {
                    case (?foundProfile) {

                        let updatedProfile : T.Profile = {
                            principalId = foundProfile.principalId;
                            username = foundProfile.username;
                            displayName = foundProfile.displayName;
                            membershipType = #Expired;
                            membershipClaims = foundProfile.membershipClaims;
                            createdOn = foundProfile.createdOn;
                            profilePicture = foundProfile.profilePicture;
                            termsAgreed = foundProfile.termsAgreed;
                            appPrincipalIds = foundProfile.appPrincipalIds;
                            subscribedChannelIds = foundProfile.subscribedChannelIds;
                            membershipExpiryTime = 0;
                            favouriteLeagueId = foundProfile.favouriteLeagueId;
                            favouriteClubId = foundProfile.favouriteClubId;
                            nationalityId = foundProfile.nationalityId;
                        };

                        let res = await saveProfile(foundGroupIndex, updatedProfile);
                        switch (res) {
                            case (#err(_)) { return };
                            case (#ok) {

                                var backend = actor (CanisterIds.ICFC_BACKEND_CANISTER_ID) : actor {
                                    removeNeuronsforExpiredMembership : shared query Ids.PrincipalId -> async ();
                                };

                                await backend.removeNeuronsforExpiredMembership(principalId);
                            };
                        };
                    };
                    case (null) {
                        return;
                    };
                };
            };
        };

    };

    private func findProfile(profileGroupIndex : Nat8, profilePrincipalId : Ids.PrincipalId) : ?T.Profile {
        switch (profileGroupIndex) {
            case 0 {
                let foundProfile = Array.find<T.Profile>(
                    profileGroup1,
                    func(profile : T.Profile) {
                        profile.principalId == profilePrincipalId;
                    },
                );
                return foundProfile;
            };
            case 1 {
                let foundProfile = Array.find<T.Profile>(
                    profileGroup2,
                    func(profile : T.Profile) {
                        profile.principalId == profilePrincipalId;
                    },
                );
                return foundProfile;
            };
            case 2 {
                let foundProfile = Array.find<T.Profile>(
                    profileGroup3,
                    func(profile : T.Profile) {
                        profile.principalId == profilePrincipalId;
                    },
                );
                return foundProfile;
            };
            case 3 {
                let foundProfile = Array.find<T.Profile>(
                    profileGroup4,
                    func(profile : T.Profile) {
                        profile.principalId == profilePrincipalId;
                    },
                );
                return foundProfile;
            };
            case 4 {
                let foundProfile = Array.find<T.Profile>(
                    profileGroup5,
                    func(profile : T.Profile) {
                        profile.principalId == profilePrincipalId;
                    },
                );
                return foundProfile;
            };
            case 5 {
                let foundProfile = Array.find<T.Profile>(
                    profileGroup6,
                    func(profile : T.Profile) {
                        profile.principalId == profilePrincipalId;
                    },
                );
                return foundProfile;
            };
            case 6 {
                let foundProfile = Array.find<T.Profile>(
                    profileGroup7,
                    func(profile : T.Profile) {
                        profile.principalId == profilePrincipalId;
                    },
                );
                return foundProfile;
            };
            case 7 {
                let foundProfile = Array.find<T.Profile>(
                    profileGroup8,
                    func(profile : T.Profile) {
                        profile.principalId == profilePrincipalId;
                    },
                );
                return foundProfile;
            };
            case 8 {
                let foundProfile = Array.find<T.Profile>(
                    profileGroup9,
                    func(profile : T.Profile) {
                        profile.principalId == profilePrincipalId;
                    },
                );
                return foundProfile;
            };
            case 9 {
                let foundProfile = Array.find<T.Profile>(
                    profileGroup10,
                    func(profile : T.Profile) {
                        profile.principalId == profilePrincipalId;
                    },
                );
                return foundProfile;
            };
            case 10 {
                let foundProfile = Array.find<T.Profile>(
                    profileGroup11,
                    func(profile : T.Profile) {
                        profile.principalId == profilePrincipalId;
                    },
                );
                return foundProfile;
            };
            case 11 {
                let foundProfile = Array.find<T.Profile>(
                    profileGroup12,
                    func(profile : T.Profile) {
                        profile.principalId == profilePrincipalId;
                    },
                );
                return foundProfile;
            };
            case _ {
                return null;
            };
        };
    };

    private func addProfile(newProfile : T.Profile) : Result.Result<(), Enums.Error> {
        switch (activeGroupIndex) {
            case 0 {
                let group1Buffer = Buffer.fromArray<T.Profile>(profileGroup1);
                group1Buffer.add(newProfile);
                profileGroup1 := Buffer.toArray(group1Buffer);

            };
            case 1 {
                let group2Buffer = Buffer.fromArray<T.Profile>(profileGroup2);
                group2Buffer.add(newProfile);
                profileGroup2 := Buffer.toArray(group2Buffer);

            };
            case 2 {
                let group3Buffer = Buffer.fromArray<T.Profile>(profileGroup3);
                group3Buffer.add(newProfile);
                profileGroup3 := Buffer.toArray(group3Buffer);
            };
            case 3 {
                let group4Buffer = Buffer.fromArray<T.Profile>(profileGroup4);
                group4Buffer.add(newProfile);
                profileGroup4 := Buffer.toArray(group4Buffer);
            };
            case 4 {
                let group5Buffer = Buffer.fromArray<T.Profile>(profileGroup5);
                group5Buffer.add(newProfile);
                profileGroup5 := Buffer.toArray(group5Buffer);
            };
            case 5 {
                let group6Buffer = Buffer.fromArray<T.Profile>(profileGroup6);
                group6Buffer.add(newProfile);
                profileGroup6 := Buffer.toArray(group6Buffer);
            };
            case 6 {
                let group7Buffer = Buffer.fromArray<T.Profile>(profileGroup7);
                group7Buffer.add(newProfile);
                profileGroup7 := Buffer.toArray(group7Buffer);
            };
            case 7 {
                let group8Buffer = Buffer.fromArray<T.Profile>(profileGroup8);
                group8Buffer.add(newProfile);
                profileGroup8 := Buffer.toArray(group8Buffer);
            };
            case 8 {
                let group9Buffer = Buffer.fromArray<T.Profile>(profileGroup9);
                group9Buffer.add(newProfile);
                profileGroup9 := Buffer.toArray(group9Buffer);
            };
            case 9 {
                let group10Buffer = Buffer.fromArray<T.Profile>(profileGroup10);
                group10Buffer.add(newProfile);
                profileGroup10 := Buffer.toArray(group10Buffer);
            };
            case 10 {
                let group11Buffer = Buffer.fromArray<T.Profile>(profileGroup11);
                group11Buffer.add(newProfile);
                profileGroup11 := Buffer.toArray(group11Buffer);
            };
            case 11 {
                let group12Buffer = Buffer.fromArray<T.Profile>(profileGroup12);
                group12Buffer.add(newProfile);
                profileGroup12 := Buffer.toArray(group12Buffer);
            };
            case _ {
                return #err(#NotFound);
            };
        };
        totalProfiles += 1;

        let groupIndexBuffer = Buffer.fromArray<(Ids.PrincipalId, Nat8)>(stable_profile_group_indexes);
        groupIndexBuffer.add((newProfile.principalId, activeGroupIndex));
        stable_profile_group_indexes := Buffer.toArray(groupIndexBuffer);
        return #ok();
    };

    private func saveProfile(profileGroupIndex : Nat8, updatedProfile : T.Profile) : async Result.Result<(), Enums.Error> {
        switch (profileGroupIndex) {
            case 0 {
                profileGroup1 := Array.map<T.Profile, T.Profile>(
                    profileGroup1,
                    func(profile : T.Profile) {
                        if (profile.principalId == updatedProfile.principalId) {
                            return updatedProfile;
                        } else {
                            return profile;
                        };
                    },
                );
            };
            case 1 {
                profileGroup2 := Array.map<T.Profile, T.Profile>(
                    profileGroup2,
                    func(profile : T.Profile) {
                        if (profile.principalId == updatedProfile.principalId) {
                            return updatedProfile;
                        } else {
                            return profile;
                        };
                    },
                );
            };
            case 2 {
                profileGroup3 := Array.map<T.Profile, T.Profile>(
                    profileGroup3,
                    func(profile : T.Profile) {
                        if (profile.principalId == updatedProfile.principalId) {
                            return updatedProfile;
                        } else {
                            return profile;
                        };
                    },
                );
            };
            case 3 {
                profileGroup4 := Array.map<T.Profile, T.Profile>(
                    profileGroup4,
                    func(profile : T.Profile) {
                        if (profile.principalId == updatedProfile.principalId) {
                            return updatedProfile;
                        } else {
                            return profile;
                        };
                    },
                );
            };
            case 4 {
                profileGroup5 := Array.map<T.Profile, T.Profile>(
                    profileGroup5,
                    func(profile : T.Profile) {
                        if (profile.principalId == updatedProfile.principalId) {
                            return updatedProfile;
                        } else {
                            return profile;
                        };
                    },
                );
            };
            case 5 {
                profileGroup6 := Array.map<T.Profile, T.Profile>(
                    profileGroup6,
                    func(profile : T.Profile) {
                        if (profile.principalId == updatedProfile.principalId) {
                            return updatedProfile;
                        } else {
                            return profile;
                        };
                    },
                );
            };
            case 6 {
                profileGroup7 := Array.map<T.Profile, T.Profile>(
                    profileGroup7,
                    func(profile : T.Profile) {
                        if (profile.principalId == updatedProfile.principalId) {
                            return updatedProfile;
                        } else {
                            return profile;
                        };
                    },
                );
            };
            case 7 {
                profileGroup8 := Array.map<T.Profile, T.Profile>(
                    profileGroup8,
                    func(profile : T.Profile) {
                        if (profile.principalId == updatedProfile.principalId) {
                            return updatedProfile;
                        } else {
                            return profile;
                        };
                    },
                );
            };
            case 8 {
                profileGroup9 := Array.map<T.Profile, T.Profile>(
                    profileGroup9,
                    func(profile : T.Profile) {
                        if (profile.principalId == updatedProfile.principalId) {
                            return updatedProfile;
                        } else {
                            return profile;
                        };
                    },
                );
            };
            case 9 {
                profileGroup10 := Array.map<T.Profile, T.Profile>(
                    profileGroup10,
                    func(profile : T.Profile) {
                        if (profile.principalId == updatedProfile.principalId) {
                            return updatedProfile;
                        } else {
                            return profile;
                        };
                    },
                );
            };
            case 10 {
                profileGroup11 := Array.map<T.Profile, T.Profile>(
                    profileGroup11,
                    func(profile : T.Profile) {
                        if (profile.principalId == updatedProfile.principalId) {
                            return updatedProfile;
                        } else {
                            return profile;
                        };
                    },
                );
            };
            case 11 {
                profileGroup12 := Array.map<T.Profile, T.Profile>(
                    profileGroup12,
                    func(profile : T.Profile) {
                        if (profile.principalId == updatedProfile.principalId) {
                            return updatedProfile;
                        } else {
                            return profile;
                        };
                    },
                );
            };
            case _ {
                return #err(#NotFound);
            };
        };

        return #ok();
    };

    private func getProfileCountInGroup(groupIndex : Nat8) : Nat {
        switch (groupIndex) {
            case 0 {
                return profileGroup1.size();
            };
            case 1 {
                return profileGroup2.size();
            };
            case 2 {
                return profileGroup3.size();
            };
            case 3 {
                return profileGroup4.size();
            };
            case 4 {
                return profileGroup5.size();
            };
            case 5 {
                return profileGroup6.size();
            };
            case 6 {
                return profileGroup7.size();
            };
            case 7 {
                return profileGroup8.size();
            };
            case 8 {
                return profileGroup9.size();
            };
            case 9 {
                return profileGroup10.size();
            };
            case 10 {
                return profileGroup11.size();
            };
            case 11 {
                return profileGroup12.size();
            };
            case _ {
                return 0;
            };
        };
    };

    public shared ({ caller }) func transferCycles(dto : CanisterCommands.TopupCanister) : async Result.Result<(), Enums.Error> {
        assert Principal.toText(caller) == CanisterIds.WATERWAY_LABS_BACKEND_CANISTER_ID;
        let result = await canisterManager.topupCanister(dto);
        switch (result) {
            case (#ok()) {
                return #ok(());
            };
            case (#err(err)) {
                return #err(err);
            };
        };

    };

    system func preupgrade() {};

    system func postupgrade() {};
};
