import T "../icfc_types";
import PodcastChannelQueries "../queries/podcast_channel_queries";
import Result "mo:base/Result";
import Principal "mo:base/Principal";
import Iter "mo:base/Iter";
import Time "mo:base/Time";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Environment "../environment";
import PodcastChannelCommands "../commands/podcast_channel_commands";

actor class _PodcastChannelsCanister() {
    private stable var MAX_PODCAST_CHANNELS_PER_GROUP : Nat = 10;
    private stable var MAX_PODCAST_CHANNELS_PER_CANISTER : Nat = 250;

    private stable var stable_podcast_channel_group_indexes : [(T.PodcastChannelId, Nat8)] = [];

    private stable var activeGroupIndex : Nat8 = 0;
    private stable var nextChannelId : T.PodcastChannelId = 1;
    private stable var totalPodcastChannels = 0;

    private stable var podcastChannelGroup1 : [T.PodcastChannel] = [];
    private stable var podcastChannelGroup2 : [T.PodcastChannel] = [];
    private stable var podcastChannelGroup3 : [T.PodcastChannel] = [];
    private stable var podcastChannelGroup4 : [T.PodcastChannel] = [];
    private stable var podcastChannelGroup5 : [T.PodcastChannel] = [];
    private stable var podcastChannelGroup6 : [T.PodcastChannel] = [];
    private stable var podcastChannelGroup7 : [T.PodcastChannel] = [];
    private stable var podcastChannelGroup8 : [T.PodcastChannel] = [];
    private stable var podcastChannelGroup9 : [T.PodcastChannel] = [];
    private stable var podcastChannelGroup10 : [T.PodcastChannel] = [];
    private stable var podcastChannelGroup11 : [T.PodcastChannel] = [];
    private stable var podcastChannelGroup12 : [T.PodcastChannel] = [];
    private stable var podcastChannelGroup13 : [T.PodcastChannel] = [];
    private stable var podcastChannelGroup14 : [T.PodcastChannel] = [];
    private stable var podcastChannelGroup15 : [T.PodcastChannel] = [];
    private stable var podcastChannelGroup16 : [T.PodcastChannel] = [];
    private stable var podcastChannelGroup17 : [T.PodcastChannel] = [];
    private stable var podcastChannelGroup18 : [T.PodcastChannel] = [];
    private stable var podcastChannelGroup19 : [T.PodcastChannel] = [];
    private stable var podcastChannelGroup20 : [T.PodcastChannel] = [];
    private stable var podcastChannelGroup21 : [T.PodcastChannel] = [];
    private stable var podcastChannelGroup22 : [T.PodcastChannel] = [];
    private stable var podcastChannelGroup23 : [T.PodcastChannel] = [];
    private stable var podcastChannelGroup24 : [T.PodcastChannel] = [];
    private stable var podcastChannelGroup25 : [T.PodcastChannel] = [];

    // Public endpoints:
    public shared ({ caller }) func getPodcastChannel(dto : PodcastChannelQueries.GetPodcastChannel) : async Result.Result<PodcastChannelQueries.PodcastChannel, T.Error> {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

        var groupIndex : ?Nat8 = null;
        for (podcastChannelGroupIndex in Iter.fromArray(stable_podcast_channel_group_indexes)) {
            if (podcastChannelGroupIndex.0 == dto.channelId) {
                groupIndex := ?podcastChannelGroupIndex.1;
            };
        };
        switch (groupIndex) {
            case (null) { return #err(#NotFound) };
            case (?foundGroupIndex) {
                let podcastChannel = findPodcastChannel(foundGroupIndex, dto.channelId);
                switch (podcastChannel) {
                    case (?foundPodcastChannel) {
                        return #ok({
                            channelId = foundPodcastChannel.id;
                            name = foundPodcastChannel.name;
                        });
                    };
                    case (null) {
                        return #err(#NotFound);
                    };
                };
            };
        };
    };

    public shared ({ caller }) func getLatestId() : async T.PodcastChannelId {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;
        return nextChannelId - 1;
    };

    public shared ({ caller }) func updateNextId(nextId : T.PodcastChannelId) : async () {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

        nextChannelId := nextId;
    };

    public shared ({ caller }) func createPodcastChannel(dto : PodcastChannelCommands.CreatePodcastChannel) : async Result.Result<(), T.Error> {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

        if (totalPodcastChannels >= MAX_PODCAST_CHANNELS_PER_CANISTER) {
            return #err(#CanisterFull);
        };

        if (getPodcastChannelCountInGroup(activeGroupIndex) >= MAX_PODCAST_CHANNELS_PER_GROUP) {
            activeGroupIndex += 1;
        };

        if (activeGroupIndex > 99) {
            return #err(#CanisterFull);
        };

        let newChannel : T.PodcastChannel = {
            id = nextChannelId;
            name = dto.name;
            createdBy = dto.createdById;
            createdOn = Time.now();
            channelImage = null;
            channelImageExtension = "";
            channelBanner = null;
            channelBannerExtension = "";
        };

        return addPodcastChannel(activeGroupIndex, newChannel);
    };

    public shared ({ caller }) func updatePodcastChannel(dto : PodcastChannelCommands.UpdatePodcastChannel) : async Result.Result<(), T.Error> {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

        var groupIndex : ?Nat8 = null;
        for (podcastChannelGroupIndex in Iter.fromArray(stable_podcast_channel_group_indexes)) {
            if (podcastChannelGroupIndex.0 == dto.channelId) {
                groupIndex := ?podcastChannelGroupIndex.1;
            };
        };
        switch (groupIndex) {
            case (null) { return #err(#NotFound) };
            case (?foundGroupIndex) {
                let podcastChannel = findPodcastChannel(foundGroupIndex, dto.channelId);
                switch (podcastChannel) {
                    case (?foundPodcastChannel) {

                        let updatedPodcastChannel : T.PodcastChannel = {
                            id = foundPodcastChannel.id;
                            name = dto.name;
                            createdBy = foundPodcastChannel.createdBy;
                            createdOn = foundPodcastChannel.createdOn;
                            channelImage = dto.channelImage;
                            channelImageExtension = dto.channelImageExtension;
                            channelBanner = dto.channelBanner;
                            channelBannerExtension = dto.channelBannerExtension;
                        };

                        return savePodcastChannel(foundGroupIndex, updatedPodcastChannel);
                    };
                    case (null) {
                        return #err(#NotFound);
                    };
                };
            };
        };
    };

    public shared ({ caller }) func deletePodcastChannel(dto : PodcastChannelCommands.DeletePodcastChannel) : async Result.Result<(), T.Error> {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

        var groupIndex : ?Nat8 = null;
        for (podcastChannelGroupIndex in Iter.fromArray(stable_podcast_channel_group_indexes)) {
            if (podcastChannelGroupIndex.0 == dto.channelId) {
                groupIndex := ?podcastChannelGroupIndex.1;
            };
        };

        switch (groupIndex) {
            case (?foundGroupIndex) {
                return removePodcastChannel(foundGroupIndex, dto.channelId);
            };
            case (null) {
                return #err(#NotFound);
            };
        };

    };

    public shared ({ caller }) func isCanisterFull() : async Bool {
        assert not Principal.isAnonymous(caller);
        let backendPrincipalId = Principal.toText(caller);
        assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;
        return (totalPodcastChannels >= MAX_PODCAST_CHANNELS_PER_CANISTER);
    };

    // Private functions:

    private func findPodcastChannel(podcastChannelGroupIndex : Nat8, channelId : T.PodcastChannelId) : ?T.PodcastChannel {
        switch (podcastChannelGroupIndex) {
            case 0 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup1,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case 1 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup2,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case 2 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup3,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case 3 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup4,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case 4 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup5,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case 5 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup6,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case 6 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup7,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case 7 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup8,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case 8 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup9,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case 9 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup10,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case 10 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup11,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case 11 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup12,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case 12 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup13,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case 13 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup14,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case 14 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup15,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case 15 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup16,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case 16 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup17,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case 17 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup18,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case 18 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup19,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case 19 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup20,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case 20 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup21,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case 21 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup22,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case 22 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup23,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case 23 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup24,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case 24 {
                let foundPodcast = Array.find<T.PodcastChannel>(
                    podcastChannelGroup25,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id == channelId;
                    },
                );
                return foundPodcast;
            };
            case _ {
                return null;
            };
        };
    };

    private func addPodcastChannel(podcastChannelGroupIndex : Nat8, newChannel : T.PodcastChannel) : Result.Result<(), T.Error> {

        var podcastChannelBuffer = Buffer.fromArray<T.PodcastChannel>([]);
        switch (activeGroupIndex) {
            case (0) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup1);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup1 := Buffer.toArray(podcastChannelBuffer);
            };
            case (1) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup2);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup2 := Buffer.toArray(podcastChannelBuffer);
            };
            case (2) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup3);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup3 := Buffer.toArray(podcastChannelBuffer);
            };
            case (3) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup4);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup4 := Buffer.toArray(podcastChannelBuffer);
            };
            case (4) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup5);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup5 := Buffer.toArray(podcastChannelBuffer);
            };
            case (5) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup6);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup6 := Buffer.toArray(podcastChannelBuffer);
            };
            case (6) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup7);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup7 := Buffer.toArray(podcastChannelBuffer);
            };
            case (7) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup8);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup8 := Buffer.toArray(podcastChannelBuffer);
            };
            case (8) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup9);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup9 := Buffer.toArray(podcastChannelBuffer);
            };
            case (9) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup10);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup10 := Buffer.toArray(podcastChannelBuffer);
            };
            case (10) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup11);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup11 := Buffer.toArray(podcastChannelBuffer);
            };
            case (11) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup12);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup12 := Buffer.toArray(podcastChannelBuffer);
            };
            case (12) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup13);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup13 := Buffer.toArray(podcastChannelBuffer);
            };
            case (13) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup14);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup14 := Buffer.toArray(podcastChannelBuffer);
            };
            case (14) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup15);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup15 := Buffer.toArray(podcastChannelBuffer);
            };
            case (15) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup16);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup16 := Buffer.toArray(podcastChannelBuffer);
            };
            case (16) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup17);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup17 := Buffer.toArray(podcastChannelBuffer);
            };
            case (17) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup18);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup18 := Buffer.toArray(podcastChannelBuffer);
            };
            case (18) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup19);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup19 := Buffer.toArray(podcastChannelBuffer);
            };
            case (19) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup20);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup20 := Buffer.toArray(podcastChannelBuffer);
            };
            case (20) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup21);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup21 := Buffer.toArray(podcastChannelBuffer);
            };
            case (21) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup22);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup22 := Buffer.toArray(podcastChannelBuffer);
            };
            case (22) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup23);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup23 := Buffer.toArray(podcastChannelBuffer);
            };
            case (23) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup24);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup24 := Buffer.toArray(podcastChannelBuffer);
            };
            case (24) {
                podcastChannelBuffer := Buffer.fromArray(podcastChannelGroup25);
                podcastChannelBuffer.add(newChannel);
                podcastChannelGroup25 := Buffer.toArray(podcastChannelBuffer);
            };
            case _ {
                return #err(#CanisterFull);
            };
        };

        totalPodcastChannels += 1;
        nextChannelId += 1;
        return #ok();
    };

    private func savePodcastChannel(groupIndex : Nat8, updatedPodcastChannel : T.PodcastChannel) : Result.Result<(), T.Error> {
        switch (groupIndex) {
            case 0 {
                podcastChannelGroup1 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup1,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
                        };
                    },
                );
            };
            case 1 {
                podcastChannelGroup2 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup2,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
                        };
                    },
                );
            };
            case 2 {
                podcastChannelGroup3 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup3,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
                        };
                    },
                );
            };
            case 3 {
                podcastChannelGroup4 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup4,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
                        };
                    },
                );
            };
            case 4 {
                podcastChannelGroup5 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup5,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
                        };
                    },
                );
            };
            case 5 {
                podcastChannelGroup6 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup6,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
                        };
                    },
                );
            };
            case 6 {
                podcastChannelGroup7 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup7,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
                        };
                    },
                );
            };
            case 7 {
                podcastChannelGroup8 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup8,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
                        };
                    },
                );
            };
            case 8 {
                podcastChannelGroup9 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup9,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
                        };
                    },
                );
            };
            case 9 {
                podcastChannelGroup10 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup10,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
                        };
                    },
                );
            };

            case 10 {
                podcastChannelGroup11 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup11,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
                        };
                    },
                );
            };
            case 11 {
                podcastChannelGroup12 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup12,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
                        };
                    },
                );
            };
            case 12 {
                podcastChannelGroup13 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup13,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
                        };
                    },
                );
            };
            case 13 {
                podcastChannelGroup14 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup14,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
                        };
                    },
                );
            };
            case 14 {
                podcastChannelGroup15 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup15,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
                        };
                    },
                );
            };
            case 15 {
                podcastChannelGroup16 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup16,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
                        };
                    },
                );
            };
            case 16 {
                podcastChannelGroup17 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup17,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
                        };
                    },
                );
            };
            case 17 {
                podcastChannelGroup18 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup18,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
                        };
                    },
                );
            };
            case 18 {
                podcastChannelGroup19 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup19,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
                        };
                    },
                );
            };
            case 19 {
                podcastChannelGroup20 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup20,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
                        };
                    },
                );
            };
            case 20 {
                podcastChannelGroup21 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup21,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
                        };
                    },
                );
            };
            case 21 {
                podcastChannelGroup22 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup22,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
                        };
                    },
                );
            };
            case 22 {
                podcastChannelGroup23 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup23,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
                        };
                    },
                );
            };
            case 23 {
                podcastChannelGroup24 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup24,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
                        };
                    },
                );
            };
            case 24 {
                podcastChannelGroup25 := Array.map<T.PodcastChannel, T.PodcastChannel>(
                    podcastChannelGroup25,
                    func(podcastChannel : T.PodcastChannel) {
                        if (podcastChannel.id == updatedPodcastChannel.id) {
                            return updatedPodcastChannel;
                        } else {
                            return podcastChannel;
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

    private func removePodcastChannel(groupIndex : Nat8, removeChannelId : T.PodcastChannelId) : Result.Result<(), T.Error> {
        switch (groupIndex) {
            case 0 {
                podcastChannelGroup1 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup1,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };
            case 1 {
                podcastChannelGroup2 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup2,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };
            case 2 {
                podcastChannelGroup3 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup3,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };
            case 3 {
                podcastChannelGroup4 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup4,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };
            case 4 {
                podcastChannelGroup5 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup5,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };
            case 5 {
                podcastChannelGroup6 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup6,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };
            case 6 {
                podcastChannelGroup7 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup7,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };
            case 7 {
                podcastChannelGroup8 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup8,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };
            case 8 {
                podcastChannelGroup9 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup9,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };
            case 9 {
                podcastChannelGroup10 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup10,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };

            case 10 {
                podcastChannelGroup11 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup11,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };
            case 11 {
                podcastChannelGroup12 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup12,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };
            case 12 {
                podcastChannelGroup13 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup13,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };
            case 13 {
                podcastChannelGroup14 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup14,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };
            case 14 {
                podcastChannelGroup15 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup15,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };
            case 15 {
                podcastChannelGroup16 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup16,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };
            case 16 {
                podcastChannelGroup17 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup17,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };
            case 17 {
                podcastChannelGroup18 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup18,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };
            case 18 {
                podcastChannelGroup19 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup19,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };
            case 19 {
                podcastChannelGroup20 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup20,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };
            case 20 {
                podcastChannelGroup21 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup21,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };
            case 21 {
                podcastChannelGroup22 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup22,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };
            case 22 {
                podcastChannelGroup23 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup23,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };
            case 23 {
                podcastChannelGroup24 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup24,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };
            case 24 {
                podcastChannelGroup25 := Array.filter<T.PodcastChannel>(
                    podcastChannelGroup25,
                    func(podcastChannel : T.PodcastChannel) {
                        podcastChannel.id != removeChannelId;
                    },
                );
            };
            case _ {
                return #err(#NotFound);
            };
        };
        return #ok();
    };

    private func getPodcastChannelCountInGroup(groupIndex : Nat8) : Nat {
        switch (groupIndex) {
            case 0 {
                return podcastChannelGroup1.size();
            };
            case 1 {
                return podcastChannelGroup2.size();
            };
            case 2 {
                return podcastChannelGroup3.size();
            };
            case 3 {
                return podcastChannelGroup4.size();
            };
            case 4 {
                return podcastChannelGroup5.size();
            };
            case 5 {
                return podcastChannelGroup6.size();
            };
            case 6 {
                return podcastChannelGroup7.size();
            };
            case 7 {
                return podcastChannelGroup8.size();
            };
            case 8 {
                return podcastChannelGroup9.size();
            };
            case 9 {
                return podcastChannelGroup10.size();
            };
            case 10 {
                return podcastChannelGroup11.size();
            };
            case 11 {
                return podcastChannelGroup12.size();
            };
            case 12 {
                return podcastChannelGroup13.size();
            };
            case 13 {
                return podcastChannelGroup14.size();
            };
            case 14 {
                return podcastChannelGroup15.size();
            };
            case 15 {
                return podcastChannelGroup16.size();
            };
            case 16 {
                return podcastChannelGroup17.size();
            };
            case 17 {
                return podcastChannelGroup18.size();
            };
            case 18 {
                return podcastChannelGroup19.size();
            };
            case 19 {
                return podcastChannelGroup20.size();
            };
            case 20 {
                return podcastChannelGroup21.size();
            };
            case 21 {
                return podcastChannelGroup22.size();
            };
            case 22 {
                return podcastChannelGroup23.size();
            };
            case 23 {
                return podcastChannelGroup24.size();
            };
            case 24 {
                return podcastChannelGroup25.size();
            };
            case _ {
                return 0;
            };
        };
    };

};
