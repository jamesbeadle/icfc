import TrieMap "mo:base/TrieMap";
import List "mo:base/List";
import Option "mo:base/Option";
import Result "mo:base/Result";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import T "../icfc_types";
import Base "mo:waterway-mops/BaseTypes";
import Utils "../utils/utils";
import PodcastChannelQueries "../queries/podcast_channel_queries";
import PodcastChannelCommands "../commands/podcast_channel_commands";
import Management "../utils/management";
import PodcastChannelsCanister "../canister_definations/podcast-channels-canister";
import Environment "../environment";
import Cycles "mo:base/ExperimentalCycles";

module {
    public class PodcastManager() {

        private var podcastChannelCanisterIndex : TrieMap.TrieMap<T.PodcastChannelId, Base.CanisterId> = TrieMap.TrieMap<T.PodcastChannelId, Base.CanisterId>(Utils.eqNat, Utils.hashNat);
        private var activeCanisterId : Base.CanisterId = "";
        private var podcastChannelNames : TrieMap.TrieMap<T.PodcastChannelId, Text> = TrieMap.TrieMap<T.PodcastChannelId, Text>(Utils.eqNat, Utils.hashNat);
        private var uniquePodcastChannelCanisterIds : List.List<Base.CanisterId> = List.nil();
        private var totalPodcastChannels : Nat = 0;
        private var nextPodcastChannelId : T.PodcastChannelId = 1;

        public func channelExists(channelId : T.PodcastChannelId) : Bool {
            let channel = podcastChannelCanisterIndex.get(channelId);
            return Option.isSome(channel);
        };

        public func getPodcastChannels(dto : PodcastChannelQueries.GetPodcastChannels) : async Result.Result<PodcastChannelQueries.PodcastChannels, T.Error> {
            let searchTerm = dto.searchTerm;
            let filteredEntries = List.filter<(T.PodcastChannelId, Text)>(
                Iter.toList<(T.PodcastChannelId, Text)>(podcastChannelNames.entries()),
                func(entry : (T.PodcastChannelId, Text)) : Bool {
                    Text.startsWith(entry.1, #text searchTerm);
                },
            );

            let droppedEntries = List.drop<(T.PodcastChannelId, Text)>(filteredEntries, 0); //TODO USE PAGE
            let paginatedEntries = List.take<(T.PodcastChannelId, Text)>(droppedEntries, 10);

            let channelsBuffer = Buffer.fromArray<PodcastChannelQueries.PodcastChannel>([]);

            for (entry in Iter.fromList(paginatedEntries)) {
                let channel = await getPodcastChannel({ channelId = entry.0 });
                switch (channel) {
                    case (#ok foundChannel) {
                        channelsBuffer.add(foundChannel);
                    };
                    case _ {};
                };
            };

            return #ok({
                entries = Buffer.toArray(channelsBuffer);
                total = 0; //TODO
                pageSize = 10;
                page = dto.page;
            });
        };

        public func getPodcastChannel(dto : PodcastChannelQueries.GetPodcastChannel) : async Result.Result<PodcastChannelQueries.PodcastChannel, T.Error> {
            return await getChannel(dto);
        };

        public func getPodcastChannelVideos(dto : PodcastChannelQueries.GetPodcastChannelVideos) : async Result.Result<PodcastChannelQueries.PodcastChannelVideos, T.Error> {
            let existingChannel = await getChannel({ channelId = dto.channelId });

            switch (existingChannel) {
                case (#ok foundChannel) {

                    let podcastChannelCanisterId = podcastChannelCanisterIndex.get(foundChannel.channelId);
                    switch (podcastChannelCanisterId) {
                        case (?foundCanisterId) {
                            let podcast_channel_canister = actor (foundCanisterId) : actor {
                                updatePodcastChannel : (dto : PodcastChannelQueries.GetPodcastChannelVideos) -> async Result.Result<PodcastChannelQueries.PodcastChannelVideos, T.Error>;
                            };
                            return await podcast_channel_canister.updatePodcastChannel(dto);
                        };
                        case _ {};
                    };
                    return #err(#NotFound);
                };
                case (#err _) { return #err(#NotFound) };
            };
        };

        private func getChannel(dto : PodcastChannelQueries.GetPodcastChannel) : async Result.Result<PodcastChannelQueries.PodcastChannel, T.Error> {
            let existingPodcastChannelCanisterId = podcastChannelCanisterIndex.get(dto.channelId);
            switch (existingPodcastChannelCanisterId) {
                case (?foundCanisterId) {

                    let podcastChannel_canister = actor (foundCanisterId) : actor {
                        getPodcastChannel : (dto : PodcastChannelQueries.GetPodcastChannel) -> async Result.Result<PodcastChannelQueries.PodcastChannel, T.Error>;
                    };

                    return await podcastChannel_canister.getPodcastChannel({
                        channelId = dto.channelId;
                    });
                };
                case (null) {
                    return #err(#NotFound);
                };
            };
        };

        public func getPodcastChannelVideo(dto : PodcastChannelQueries.GetPodcastChannelVideo) : async Result.Result<PodcastChannelQueries.PodcastChannelVideo, T.Error> {
            let existingPodcastChannelCanisterId = podcastChannelCanisterIndex.get(dto.channelId);
            switch (existingPodcastChannelCanisterId) {
                case (?foundCanisterId) {

                    let podcastChannel_canister = actor (foundCanisterId) : actor {
                        getPodcastChannelVideo : (dto : PodcastChannelQueries.GetPodcastChannelVideo) -> async Result.Result<PodcastChannelQueries.PodcastChannelVideo, T.Error>;
                    };

                    return await podcastChannel_canister.getPodcastChannelVideo({
                        channelId = dto.channelId;
                    });
                };
                case (null) {
                    return #err(#NotFound);
                };
            };
        };
        public func isSubscribed(dto : PodcastChannelQueries.IsSubscribed) : async Bool {
            let existingPodcastChannelCanisterId = podcastChannelCanisterIndex.get(dto.channelId);
            switch (existingPodcastChannelCanisterId) {
                case (?foundCanisterId) {

                    let podcastChannel_canister = actor (foundCanisterId) : actor {
                        isSubscribed : (dto : PodcastChannelQueries.IsSubscribed) -> async Bool;
                    };

                    return await podcastChannel_canister.isSubscribed({
                        channelId = dto.channelId;
                        principalId = dto.principalId;
                    });
                };
                case (null) {};
            };
            return false;
        };

        public func createPodcastChannel(dto : PodcastChannelCommands.CreatePodcastChannel) : async Result.Result<T.PodcastChannelId, T.Error> {

            if (Text.size(dto.name) > 100) {
                return #err(#TooLong);
            };

            var podcast_channel_canister = actor (activeCanisterId) : actor {
                createPodcastChannel : (dto : PodcastChannelCommands.CreatePodcastChannel) -> async Result.Result<T.PodcastChannelId, T.Error>;
                getLatestId : () -> async T.PodcastChannelId;
                isCanisterFull : () -> async Bool;
            };

            switch (activeCanisterId) {
                case "" {
                    await createNewCanister(totalPodcastChannels + 1);
                    podcast_channel_canister := actor (activeCanisterId) : actor {
                        createPodcastChannel : (dto : PodcastChannelCommands.CreatePodcastChannel) -> async Result.Result<T.PodcastChannelId, T.Error>;
                        getLatestId : () -> async T.PodcastChannelId;
                        isCanisterFull : () -> async Bool;
                    };
                };
                case _ {
                    let isCanisterFull = await podcast_channel_canister.isCanisterFull();
                    if (isCanisterFull) {
                        let latestId = await podcast_channel_canister.getLatestId();
                        let nextId : T.PodcastChannelId = latestId + 1;
                        await createNewCanister(nextId);
                        podcast_channel_canister := actor (activeCanisterId) : actor {
                            createPodcastChannel : (dto : PodcastChannelCommands.CreatePodcastChannel) -> async Result.Result<T.PodcastChannelId, T.Error>;
                            getLatestId : () -> async T.PodcastChannelId;
                            isCanisterFull : () -> async Bool;
                        };
                    };
                };
            };
            return await podcast_channel_canister.createPodcastChannel(dto);
        };
        public func updatePodcastChannel(dto : PodcastChannelCommands.UpdatePodcastChannel) : async Result.Result<(), T.Error> {
            let existingChannel = await getChannel({ channelId = dto.channelId });

            switch (existingChannel) {
                case (#ok foundChannel) {

                    let podcastChannelCanisterId = podcastChannelCanisterIndex.get(foundChannel.channelId);
                    switch (podcastChannelCanisterId) {
                        case (?foundCanisterId) {
                            let podcast_channel_canister = actor (foundCanisterId) : actor {
                                updatePodcastChannel : (dto : PodcastChannelCommands.UpdatePodcastChannel) -> async Result.Result<(), T.Error>;
                            };
                            return await podcast_channel_canister.updatePodcastChannel(dto);
                        };
                        case _ {};
                    };
                    return #err(#NotFound);
                };
                case (#err _) { return #err(#NotFound) };
            };
        };

        public func deletePodcastChannel(dto : PodcastChannelCommands.DeletePodcastChannel) : async Result.Result<(), T.Error> {
            let existingChannel = await getChannel({ channelId = dto.channelId });

            switch (existingChannel) {
                case (#ok foundChannel) {

                    let podcastChannelCanisterId = podcastChannelCanisterIndex.get(foundChannel.channelId);
                    switch (podcastChannelCanisterId) {
                        case (?foundCanisterId) {
                            let podcast_channel_canister = actor (foundCanisterId) : actor {
                                deletePodcastChannel : (dto : PodcastChannelCommands.DeletePodcastChannel) -> async Result.Result<(), T.Error>;
                            };
                            return await podcast_channel_canister.deletePodcastChannel(dto);
                        };
                        case _ {};
                    };
                    return #err(#NotFound);
                };
                case (#err _) { return #err(#NotFound) };
            };
        };

        public func subscribeToPodcastChannel(dto : PodcastChannelCommands.SubscribeToPodcastChannel) : async Result.Result<(), T.Error> {
            let existingChannel = await getChannel({ channelId = dto.channelId });

            switch (existingChannel) {
                case (#ok foundChannel) {

                    let podcastChannelCanisterId = podcastChannelCanisterIndex.get(foundChannel.channelId);
                    switch (podcastChannelCanisterId) {
                        case (?foundCanisterId) {
                            let podcast_channel_canister = actor (foundCanisterId) : actor {
                                subscribeToPodcastChannel : (dto : PodcastChannelCommands.SubscribeToPodcastChannel) -> async Result.Result<(), T.Error>;
                            };
                            return await podcast_channel_canister.subscribeToPodcastChannel(dto);
                        };
                        case _ {};
                    };
                    return #err(#NotFound);
                };
                case (#err _) { return #err(#NotFound) };
            };
        };

        public func unsubscribeFromPodcastChannel(dto : PodcastChannelCommands.UnsubscribeFromPodcastChannel) : async Result.Result<(), T.Error> {
            let existingChannel = await getChannel({ channelId = dto.channelId });

            switch (existingChannel) {
                case (#ok foundChannel) {

                    let podcastChannelCanisterId = podcastChannelCanisterIndex.get(foundChannel.channelId);
                    switch (podcastChannelCanisterId) {
                        case (?foundCanisterId) {
                            let podcast_channel_canister = actor (foundCanisterId) : actor {
                                unsubscribeFromPodcastChannel : (dto : PodcastChannelCommands.UnsubscribeFromPodcastChannel) -> async Result.Result<(), T.Error>;
                            };
                            return await podcast_channel_canister.unsubscribeFromPodcastChannel(dto);
                        };
                        case _ {};
                    };
                    return #err(#NotFound);
                };
                case (#err _) { return #err(#NotFound) };
            };
        };

        public func uploadPodcastChannelVideo(dto : PodcastChannelCommands.UploadPodcastChannelVideo) : async Result.Result<(), T.Error> {
            let existingChannel = await getChannel({ channelId = dto.channelId });

            switch (existingChannel) {
                case (#ok foundChannel) {

                    let podcastChannelCanisterId = podcastChannelCanisterIndex.get(foundChannel.channelId);
                    switch (podcastChannelCanisterId) {
                        case (?foundCanisterId) {
                            let podcast_channel_canister = actor (foundCanisterId) : actor {
                                uploadPodcastChannelVideo : (dto : PodcastChannelCommands.UploadPodcastChannelVideo) -> async Result.Result<(), T.Error>;
                            };
                            return await podcast_channel_canister.uploadPodcastChannelVideo(dto);
                        };
                        case _ {};
                    };
                    return #err(#NotFound);
                };
                case (#err _) { return #err(#NotFound) };
            };
        };

        public func updatePodcastChannelVideo(dto : PodcastChannelCommands.UpdatePodcastChannelVideo) : async Result.Result<(), T.Error> {
            let existingChannel = await getChannel({ channelId = dto.channelId });

            switch (existingChannel) {
                case (#ok foundChannel) {

                    let podcastChannelCanisterId = podcastChannelCanisterIndex.get(foundChannel.channelId);
                    switch (podcastChannelCanisterId) {
                        case (?foundCanisterId) {
                            let podcast_channel_canister = actor (foundCanisterId) : actor {
                                updatePodcastChannelVideo : (dto : PodcastChannelCommands.UpdatePodcastChannelVideo) -> async Result.Result<(), T.Error>;
                            };
                            return await podcast_channel_canister.updatePodcastChannelVideo(dto);
                        };
                        case _ {};
                    };
                    return #err(#NotFound);
                };
                case (#err _) { return #err(#NotFound) };
            };
        };

        public func removePodcastChannelVideo(dto : PodcastChannelCommands.RemovePodcastChannelVideo) : async Result.Result<(), T.Error> {
            let existingChannel = await getChannel({ channelId = dto.channelId });

            switch (existingChannel) {
                case (#ok foundChannel) {

                    let podcastChannelCanisterId = podcastChannelCanisterIndex.get(foundChannel.channelId);
                    switch (podcastChannelCanisterId) {
                        case (?foundCanisterId) {
                            let podcast_channel_canister = actor (foundCanisterId) : actor {
                                removePodcastChannelVideo : (dto : PodcastChannelCommands.RemovePodcastChannelVideo) -> async Result.Result<(), T.Error>;
                            };
                            return await podcast_channel_canister.removePodcastChannelVideo(dto);
                        };
                        case _ {};
                    };
                    return #err(#NotFound);
                };
                case (#err _) { return #err(#NotFound) };
            };
        };

        public func isChannelOwner(dto : PodcastChannelQueries.IsChannelOwner) : async Bool {
            let existingChannel = await getChannel({ channelId = dto.channelId });

            switch (existingChannel) {
                case (#ok foundChannel) {

                    let podcastChannelCanisterId = podcastChannelCanisterIndex.get(foundChannel.channelId);
                    switch (podcastChannelCanisterId) {
                        case (?foundCanisterId) {
                            let podcast_channel_canister = actor (foundCanisterId) : actor {
                                isChannelOwner : (dto : PodcastChannelQueries.IsChannelOwner) -> async Bool;
                            };
                            return await podcast_channel_canister.isChannelOwner(dto);
                        };
                        case _ {};
                    };
                };
                case (#err _) {};
            };
            return false;
        };

        //stable storage getters and setters

        public func getStableCanisterIndex() : [(T.PodcastChannelId, Base.CanisterId)] {
            return Iter.toArray(podcastChannelCanisterIndex.entries());
        };

        public func setStableCanisterIndex(stable_podcast_channel_canister_index : [(T.PodcastChannelId, Base.CanisterId)]) {
            let canisterIds : TrieMap.TrieMap<T.PodcastChannelId, Base.CanisterId> = TrieMap.TrieMap<T.PodcastChannelId, Base.CanisterId>(Utils.eqNat, Utils.hashNat);

            for (canisterId in Iter.fromArray(stable_podcast_channel_canister_index)) {
                canisterIds.put(canisterId);
            };
            podcastChannelCanisterIndex := canisterIds;
        };

        public func getStableActiveCanisterId() : Base.CanisterId {
            return activeCanisterId;
        };

        public func setStableActiveCanisterId(stable_active_canister_id : Base.CanisterId) {
            activeCanisterId := stable_active_canister_id;
        };

        public func getStablePodcastChannelNames() : [(T.PodcastChannelId, Text)] {
            return Iter.toArray(podcastChannelNames.entries());
        };

        public func setStablePodcastChannelNames(stable_channel_names : [(T.PodcastChannelId, Text)]) : () {
            let podcast_channel_map : TrieMap.TrieMap<T.PodcastChannelId, Base.CanisterId> = TrieMap.TrieMap<T.PodcastChannelId, Base.CanisterId>(Utils.eqNat, Utils.hashNat);

            for (channelName in Iter.fromArray(stable_channel_names)) {
                podcast_channel_map.put(channelName);
            };
            podcastChannelNames := podcast_channel_map;
        };

        public func getStableUniqueCanisterIds() : [Base.CanisterId] {
            return List.toArray(uniquePodcastChannelCanisterIds);
        };

        public func setStableUniqueCanisterIds(stable_unique_canister_ids : [Base.CanisterId]) : () {
            let canisterIdBuffer = Buffer.fromArray<Base.CanisterId>([]);

            for (canisterId in Iter.fromArray(stable_unique_canister_ids)) {
                canisterIdBuffer.add(canisterId);
            };
            uniquePodcastChannelCanisterIds := List.fromArray(Buffer.toArray(canisterIdBuffer));
        };

        public func getStableTotalPodcastChannels() : Nat {
            return totalPodcastChannels;
        };

        public func setStableTotalPodcastChannels(stable_total_podcast_channels : Nat) : () {
            totalPodcastChannels := stable_total_podcast_channels;
        };

        public func getStableNextPodcastChannelId() : T.PodcastChannelId {
            return nextPodcastChannelId;
        };

        public func setStableNextPodcastChannelId(stable_next_podcast_channel_id : T.PodcastChannelId) : () {
            nextPodcastChannelId := stable_next_podcast_channel_id;
        };

        //TODO WHEN?!

        private func createNewCanister(nextId : T.PodcastChannelId) : async () {
            Cycles.add<system>(10_000_000_000_000);
            let canister = await PodcastChannelsCanister._PodcastChannelsCanister();
            let IC : Management.Management = actor (Environment.Default);
            let principal = ?Principal.fromText(Environment.BACKEND_CANISTER_ID);
            let _ = await Utils.updateCanister_(canister, principal, IC);

            let canister_principal = Principal.fromActor(canister);
            let canisterId = Principal.toText(canister_principal);

            if (canisterId == "") {
                return;
            };

            var new_canister = actor (canisterId) : actor {
                updateNextId : (nextId : T.PodcastChannelId) -> async ();
            };

            await new_canister.updateNextId(nextId);

            let uniqueCanisterIdBuffer = Buffer.fromArray<Base.CanisterId>(List.toArray(uniquePodcastChannelCanisterIds));
            uniqueCanisterIdBuffer.add(canisterId);
            uniquePodcastChannelCanisterIds := List.fromArray(Buffer.toArray(uniqueCanisterIdBuffer));
            activeCanisterId := canisterId;
            return;
        };
    };

};
