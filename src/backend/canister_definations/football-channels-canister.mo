import T "../icfc_types";
import FootballChannelQueries "../queries/football_channel_queries";
import Result "mo:base/Result";
import Principal "mo:base/Principal";
import Iter "mo:base/Iter";
import Time "mo:base/Time";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Enums "mo:waterway-mops/Enums";
import CanisterIds "mo:waterway-mops/CanisterIds";
import Environment "../environment";
import FootballChannelCommands "../commands/football_channel_commands";

actor class _FootballChannelsCanister() {
    private stable var MAX_PODCAST_CHANNELS_PER_GROUP : Nat = 10;
    private stable var MAX_PODCAST_CHANNELS_PER_CANISTER : Nat = 250;

    private stable var stable_football_channel_group_indexes : [(T.FootballChannelId, Nat8)] = [];

    private stable var activeGroupIndex : Nat8 = 0;
    private stable var nextChannelId : T.FootballChannelId = 1;
    private stable var totalFootballChannels = 0;

    private stable var footballChannelGroup1 : [T.FootballChannel] = [];
    private stable var footballChannelGroup2 : [T.FootballChannel] = [];
    private stable var footballChannelGroup3 : [T.FootballChannel] = [];
    private stable var footballChannelGroup4 : [T.FootballChannel] = [];
    private stable var footballChannelGroup5 : [T.FootballChannel] = [];
    private stable var footballChannelGroup6 : [T.FootballChannel] = [];
    private stable var footballChannelGroup7 : [T.FootballChannel] = [];
    private stable var footballChannelGroup8 : [T.FootballChannel] = [];
    private stable var footballChannelGroup9 : [T.FootballChannel] = [];
    private stable var footballChannelGroup10 : [T.FootballChannel] = [];
    private stable var footballChannelGroup11 : [T.FootballChannel] = [];
    private stable var footballChannelGroup12 : [T.FootballChannel] = [];
    private stable var footballChannelGroup13 : [T.FootballChannel] = [];
    private stable var footballChannelGroup14 : [T.FootballChannel] = [];
    private stable var footballChannelGroup15 : [T.FootballChannel] = [];
    private stable var footballChannelGroup16 : [T.FootballChannel] = [];
    private stable var footballChannelGroup17 : [T.FootballChannel] = [];
    private stable var footballChannelGroup18 : [T.FootballChannel] = [];
    private stable var footballChannelGroup19 : [T.FootballChannel] = [];
    private stable var footballChannelGroup20 : [T.FootballChannel] = [];
    private stable var footballChannelGroup21 : [T.FootballChannel] = [];
    private stable var footballChannelGroup22 : [T.FootballChannel] = [];
    private stable var footballChannelGroup23 : [T.FootballChannel] = [];
    private stable var footballChannelGroup24 : [T.FootballChannel] = [];
    private stable var footballChannelGroup25 : [T.FootballChannel] = [];

    // Public endpoints:
    public shared ({ caller }) func getFootballChannel(dto : FootballChannelQueries.GetFootballChannel) : async Result.Result<FootballChannelQueries.FootballChannel, Enums.Error> {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == CanisterIds.ICFC_BACKEND_CANISTER_ID;

        var groupIndex : ?Nat8 = null;
        for (footballChannelGroupIndex in Iter.fromArray(stable_football_channel_group_indexes)) {
            if (footballChannelGroupIndex.0 == dto.channelId) {
                groupIndex := ?footballChannelGroupIndex.1;
            };
        };
        switch (groupIndex) {
            case (null) { return #err(#NotFound) };
            case (?foundGroupIndex) {
                let footballChannel = findFootballChannel(foundGroupIndex, dto.channelId);
                switch (footballChannel) {
                    case (?foundFootballChannel) {
                        return #ok({
                            channelId = foundFootballChannel.id;
                            name = foundFootballChannel.name;
                        });
                    };
                    case (null) {
                        return #err(#NotFound);
                    };
                };
            };
        };
    };

    public shared ({ caller }) func getLatestId() : async T.FootballChannelId {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == CanisterIds.ICFC_BACKEND_CANISTER_ID;
        return nextChannelId - 1;
    };

    public shared ({ caller }) func updateNextId(nextId : T.FootballChannelId) : async () {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == CanisterIds.ICFC_BACKEND_CANISTER_ID;

        nextChannelId := nextId;
    };

    public shared ({ caller }) func createFootballChannel(dto : FootballChannelCommands.CreateFootballChannel) : async Result.Result<(), Enums.Error> {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == CanisterIds.ICFC_BACKEND_CANISTER_ID;

        if (totalFootballChannels >= MAX_PODCAST_CHANNELS_PER_CANISTER) {
            return #err(#MaxDataExceeded);
        };

        if (getFootballChannelCountInGroup(activeGroupIndex) >= MAX_PODCAST_CHANNELS_PER_GROUP) {
            activeGroupIndex += 1;
        };

        if (activeGroupIndex > 99) {
            return #err(#MaxDataExceeded);
        };

        let newChannel : T.FootballChannel = {
            id = nextChannelId;
            name = dto.name;
            createdBy = dto.createdById;
            createdOn = Time.now();
            channelImage = null;
            channelImageExtension = "";
            channelBanner = null;
            channelBannerExtension = "";
        };

        return addFootballChannel(activeGroupIndex, newChannel);
    };

    public shared ({ caller }) func updateFootballChannel(dto : FootballChannelCommands.UpdateFootballChannel) : async Result.Result<(), Enums.Error> {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == CanisterIds.ICFC_BACKEND_CANISTER_ID;

        var groupIndex : ?Nat8 = null;
        for (footballChannelGroupIndex in Iter.fromArray(stable_football_channel_group_indexes)) {
            if (footballChannelGroupIndex.0 == dto.channelId) {
                groupIndex := ?footballChannelGroupIndex.1;
            };
        };
        switch (groupIndex) {
            case (null) { return #err(#NotFound) };
            case (?foundGroupIndex) {
                let footballChannel = findFootballChannel(foundGroupIndex, dto.channelId);
                switch (footballChannel) {
                    case (?foundFootballChannel) {

                        let updatedFootballChannel : T.FootballChannel = {
                            id = foundFootballChannel.id;
                            name = dto.name;
                            createdBy = foundFootballChannel.createdBy;
                            createdOn = foundFootballChannel.createdOn;
                            channelImage = dto.channelImage;
                            channelImageExtension = dto.channelImageExtension;
                            channelBanner = dto.channelBanner;
                            channelBannerExtension = dto.channelBannerExtension;
                        };

                        return saveFootballChannel(foundGroupIndex, updatedFootballChannel);
                    };
                    case (null) {
                        return #err(#NotFound);
                    };
                };
            };
        };
    };

    public shared ({ caller }) func deleteFootballChannel(dto : FootballChannelCommands.DeleteFootballChannel) : async Result.Result<(), Enums.Error> {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == CanisterIds.ICFC_BACKEND_CANISTER_ID;

        var groupIndex : ?Nat8 = null;
        for (footballChannelGroupIndex in Iter.fromArray(stable_football_channel_group_indexes)) {
            if (footballChannelGroupIndex.0 == dto.channelId) {
                groupIndex := ?footballChannelGroupIndex.1;
            };
        };

        switch (groupIndex) {
            case (?foundGroupIndex) {
                return removeFootballChannel(foundGroupIndex, dto.channelId);
            };
            case (null) {
                return #err(#NotFound);
            };
        };

    };

    public shared ({ caller }) func isCanisterFull() : async Bool {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == CanisterIds.ICFC_BACKEND_CANISTER_ID;
        return (totalFootballChannels >= MAX_PODCAST_CHANNELS_PER_CANISTER);
    };

    // Private functions:

    private func findFootballChannel(footballChannelGroupIndex : Nat8, channelId : T.FootballChannelId) : ?T.FootballChannel {
        switch (footballChannelGroupIndex) {
            case 0 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup1,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case 1 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup2,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case 2 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup3,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case 3 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup4,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case 4 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup5,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case 5 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup6,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case 6 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup7,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case 7 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup8,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case 8 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup9,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case 9 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup10,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case 10 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup11,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case 11 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup12,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case 12 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup13,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case 13 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup14,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case 14 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup15,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case 15 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup16,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case 16 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup17,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case 17 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup18,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case 18 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup19,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case 19 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup20,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case 20 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup21,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case 21 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup22,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case 22 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup23,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case 23 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup24,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case 24 {
                let foundFootball = Array.find<T.FootballChannel>(
                    footballChannelGroup25,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id == channelId;
                    },
                );
                return foundFootball;
            };
            case _ {
                return null;
            };
        };
    };

    private func addFootballChannel(footballChannelGroupIndex : Nat8, newChannel : T.FootballChannel) : Result.Result<(), Enums.Error> {

        var footballChannelBuffer = Buffer.fromArray<T.FootballChannel>([]);
        switch (activeGroupIndex) {
            case (0) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup1);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup1 := Buffer.toArray(footballChannelBuffer);
            };
            case (1) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup2);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup2 := Buffer.toArray(footballChannelBuffer);
            };
            case (2) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup3);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup3 := Buffer.toArray(footballChannelBuffer);
            };
            case (3) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup4);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup4 := Buffer.toArray(footballChannelBuffer);
            };
            case (4) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup5);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup5 := Buffer.toArray(footballChannelBuffer);
            };
            case (5) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup6);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup6 := Buffer.toArray(footballChannelBuffer);
            };
            case (6) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup7);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup7 := Buffer.toArray(footballChannelBuffer);
            };
            case (7) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup8);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup8 := Buffer.toArray(footballChannelBuffer);
            };
            case (8) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup9);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup9 := Buffer.toArray(footballChannelBuffer);
            };
            case (9) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup10);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup10 := Buffer.toArray(footballChannelBuffer);
            };
            case (10) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup11);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup11 := Buffer.toArray(footballChannelBuffer);
            };
            case (11) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup12);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup12 := Buffer.toArray(footballChannelBuffer);
            };
            case (12) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup13);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup13 := Buffer.toArray(footballChannelBuffer);
            };
            case (13) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup14);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup14 := Buffer.toArray(footballChannelBuffer);
            };
            case (14) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup15);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup15 := Buffer.toArray(footballChannelBuffer);
            };
            case (15) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup16);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup16 := Buffer.toArray(footballChannelBuffer);
            };
            case (16) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup17);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup17 := Buffer.toArray(footballChannelBuffer);
            };
            case (17) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup18);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup18 := Buffer.toArray(footballChannelBuffer);
            };
            case (18) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup19);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup19 := Buffer.toArray(footballChannelBuffer);
            };
            case (19) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup20);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup20 := Buffer.toArray(footballChannelBuffer);
            };
            case (20) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup21);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup21 := Buffer.toArray(footballChannelBuffer);
            };
            case (21) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup22);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup22 := Buffer.toArray(footballChannelBuffer);
            };
            case (22) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup23);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup23 := Buffer.toArray(footballChannelBuffer);
            };
            case (23) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup24);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup24 := Buffer.toArray(footballChannelBuffer);
            };
            case (24) {
                footballChannelBuffer := Buffer.fromArray(footballChannelGroup25);
                footballChannelBuffer.add(newChannel);
                footballChannelGroup25 := Buffer.toArray(footballChannelBuffer);
            };
            case _ {
                return #err(#MaxDataExceeded);
            };
        };

        totalFootballChannels += 1;
        nextChannelId += 1;
        return #ok();
    };

    private func saveFootballChannel(groupIndex : Nat8, updatedFootballChannel : T.FootballChannel) : Result.Result<(), Enums.Error> {
        switch (groupIndex) {
            case 0 {
                footballChannelGroup1 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup1,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
                        };
                    },
                );
            };
            case 1 {
                footballChannelGroup2 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup2,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
                        };
                    },
                );
            };
            case 2 {
                footballChannelGroup3 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup3,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
                        };
                    },
                );
            };
            case 3 {
                footballChannelGroup4 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup4,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
                        };
                    },
                );
            };
            case 4 {
                footballChannelGroup5 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup5,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
                        };
                    },
                );
            };
            case 5 {
                footballChannelGroup6 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup6,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
                        };
                    },
                );
            };
            case 6 {
                footballChannelGroup7 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup7,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
                        };
                    },
                );
            };
            case 7 {
                footballChannelGroup8 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup8,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
                        };
                    },
                );
            };
            case 8 {
                footballChannelGroup9 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup9,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
                        };
                    },
                );
            };
            case 9 {
                footballChannelGroup10 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup10,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
                        };
                    },
                );
            };

            case 10 {
                footballChannelGroup11 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup11,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
                        };
                    },
                );
            };
            case 11 {
                footballChannelGroup12 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup12,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
                        };
                    },
                );
            };
            case 12 {
                footballChannelGroup13 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup13,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
                        };
                    },
                );
            };
            case 13 {
                footballChannelGroup14 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup14,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
                        };
                    },
                );
            };
            case 14 {
                footballChannelGroup15 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup15,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
                        };
                    },
                );
            };
            case 15 {
                footballChannelGroup16 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup16,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
                        };
                    },
                );
            };
            case 16 {
                footballChannelGroup17 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup17,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
                        };
                    },
                );
            };
            case 17 {
                footballChannelGroup18 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup18,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
                        };
                    },
                );
            };
            case 18 {
                footballChannelGroup19 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup19,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
                        };
                    },
                );
            };
            case 19 {
                footballChannelGroup20 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup20,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
                        };
                    },
                );
            };
            case 20 {
                footballChannelGroup21 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup21,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
                        };
                    },
                );
            };
            case 21 {
                footballChannelGroup22 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup22,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
                        };
                    },
                );
            };
            case 22 {
                footballChannelGroup23 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup23,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
                        };
                    },
                );
            };
            case 23 {
                footballChannelGroup24 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup24,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
                        };
                    },
                );
            };
            case 24 {
                footballChannelGroup25 := Array.map<T.FootballChannel, T.FootballChannel>(
                    footballChannelGroup25,
                    func(footballChannel : T.FootballChannel) {
                        if (footballChannel.id == updatedFootballChannel.id) {
                            return updatedFootballChannel;
                        } else {
                            return footballChannel;
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

    private func removeFootballChannel(groupIndex : Nat8, removeChannelId : T.FootballChannelId) : Result.Result<(), Enums.Error> {
        switch (groupIndex) {
            case 0 {
                footballChannelGroup1 := Array.filter<T.FootballChannel>(
                    footballChannelGroup1,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };
            case 1 {
                footballChannelGroup2 := Array.filter<T.FootballChannel>(
                    footballChannelGroup2,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };
            case 2 {
                footballChannelGroup3 := Array.filter<T.FootballChannel>(
                    footballChannelGroup3,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };
            case 3 {
                footballChannelGroup4 := Array.filter<T.FootballChannel>(
                    footballChannelGroup4,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };
            case 4 {
                footballChannelGroup5 := Array.filter<T.FootballChannel>(
                    footballChannelGroup5,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };
            case 5 {
                footballChannelGroup6 := Array.filter<T.FootballChannel>(
                    footballChannelGroup6,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };
            case 6 {
                footballChannelGroup7 := Array.filter<T.FootballChannel>(
                    footballChannelGroup7,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };
            case 7 {
                footballChannelGroup8 := Array.filter<T.FootballChannel>(
                    footballChannelGroup8,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };
            case 8 {
                footballChannelGroup9 := Array.filter<T.FootballChannel>(
                    footballChannelGroup9,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };
            case 9 {
                footballChannelGroup10 := Array.filter<T.FootballChannel>(
                    footballChannelGroup10,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };

            case 10 {
                footballChannelGroup11 := Array.filter<T.FootballChannel>(
                    footballChannelGroup11,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };
            case 11 {
                footballChannelGroup12 := Array.filter<T.FootballChannel>(
                    footballChannelGroup12,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };
            case 12 {
                footballChannelGroup13 := Array.filter<T.FootballChannel>(
                    footballChannelGroup13,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };
            case 13 {
                footballChannelGroup14 := Array.filter<T.FootballChannel>(
                    footballChannelGroup14,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };
            case 14 {
                footballChannelGroup15 := Array.filter<T.FootballChannel>(
                    footballChannelGroup15,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };
            case 15 {
                footballChannelGroup16 := Array.filter<T.FootballChannel>(
                    footballChannelGroup16,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };
            case 16 {
                footballChannelGroup17 := Array.filter<T.FootballChannel>(
                    footballChannelGroup17,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };
            case 17 {
                footballChannelGroup18 := Array.filter<T.FootballChannel>(
                    footballChannelGroup18,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };
            case 18 {
                footballChannelGroup19 := Array.filter<T.FootballChannel>(
                    footballChannelGroup19,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };
            case 19 {
                footballChannelGroup20 := Array.filter<T.FootballChannel>(
                    footballChannelGroup20,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };
            case 20 {
                footballChannelGroup21 := Array.filter<T.FootballChannel>(
                    footballChannelGroup21,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };
            case 21 {
                footballChannelGroup22 := Array.filter<T.FootballChannel>(
                    footballChannelGroup22,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };
            case 22 {
                footballChannelGroup23 := Array.filter<T.FootballChannel>(
                    footballChannelGroup23,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };
            case 23 {
                footballChannelGroup24 := Array.filter<T.FootballChannel>(
                    footballChannelGroup24,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };
            case 24 {
                footballChannelGroup25 := Array.filter<T.FootballChannel>(
                    footballChannelGroup25,
                    func(footballChannel : T.FootballChannel) {
                        footballChannel.id != removeChannelId;
                    },
                );
            };
            case _ {
                return #err(#NotFound);
            };
        };
        return #ok();
    };

    private func getFootballChannelCountInGroup(groupIndex : Nat8) : Nat {
        switch (groupIndex) {
            case 0 {
                return footballChannelGroup1.size();
            };
            case 1 {
                return footballChannelGroup2.size();
            };
            case 2 {
                return footballChannelGroup3.size();
            };
            case 3 {
                return footballChannelGroup4.size();
            };
            case 4 {
                return footballChannelGroup5.size();
            };
            case 5 {
                return footballChannelGroup6.size();
            };
            case 6 {
                return footballChannelGroup7.size();
            };
            case 7 {
                return footballChannelGroup8.size();
            };
            case 8 {
                return footballChannelGroup9.size();
            };
            case 9 {
                return footballChannelGroup10.size();
            };
            case 10 {
                return footballChannelGroup11.size();
            };
            case 11 {
                return footballChannelGroup12.size();
            };
            case 12 {
                return footballChannelGroup13.size();
            };
            case 13 {
                return footballChannelGroup14.size();
            };
            case 14 {
                return footballChannelGroup15.size();
            };
            case 15 {
                return footballChannelGroup16.size();
            };
            case 16 {
                return footballChannelGroup17.size();
            };
            case 17 {
                return footballChannelGroup18.size();
            };
            case 18 {
                return footballChannelGroup19.size();
            };
            case 19 {
                return footballChannelGroup20.size();
            };
            case 20 {
                return footballChannelGroup21.size();
            };
            case 21 {
                return footballChannelGroup22.size();
            };
            case 22 {
                return footballChannelGroup23.size();
            };
            case 23 {
                return footballChannelGroup24.size();
            };
            case 24 {
                return footballChannelGroup25.size();
            };
            case _ {
                return 0;
            };
        };
    };

};
