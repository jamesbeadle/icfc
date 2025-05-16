import TrieMap "mo:base/TrieMap";
import List "mo:base/List";
import Option "mo:base/Option";
import Result "mo:base/Result";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import T "../icfc_types";
import Ids "mo:waterway-mops/Ids";
import Enums "mo:waterway-mops/Enums";
import CanisterIds "mo:waterway-mops/CanisterIds";
import BaseUtilities "mo:waterway-mops/BaseUtilities";
import FootballChannelQueries "../queries/football_channel_queries";
import FootballChannelCommands "../commands/football_channel_commands";
import FootballChannelsCanister "../canister_definitions/football-channels-canister";
import Cycles "mo:base/ExperimentalCycles";
import Management "mo:waterway-mops/Management";
import CanisterUtilities "mo:waterway-mops/CanisterUtilities";

module {
    public class FootballChannelManager() {

        private var footballChannelCanisterIndex : TrieMap.TrieMap<Ids.FootballChannelId, Ids.CanisterId> = TrieMap.TrieMap<Ids.FootballChannelId, Ids.CanisterId>(BaseUtilities.eqNat, BaseUtilities.hashNat);
        private var activeCanisterId : Ids.CanisterId = "";
        private var footballChannelNames : TrieMap.TrieMap<Ids.FootballChannelId, Text> = TrieMap.TrieMap<Ids.FootballChannelId, Text>(BaseUtilities.eqNat, BaseUtilities.hashNat);
        private var uniqueFootballChannelCanisterIds : List.List<Ids.CanisterId> = List.nil();
        private var totalFootballChannels : Nat = 0;
        private var nextFootballChannelId : Ids.FootballChannelId = 1;

        public func channelExists(channelId : Ids.FootballChannelId) : Bool {
            let channel = footballChannelCanisterIndex.get(channelId);
            return Option.isSome(channel);
        };

        public func getFootballChannels(dto : FootballChannelQueries.GetFootballChannels) : async Result.Result<FootballChannelQueries.FootballChannels, Enums.Error> {
            let searchTerm = dto.searchTerm;
            let filteredEntries = List.filter<(Ids.FootballChannelId, Text)>(
                Iter.toList<(Ids.FootballChannelId, Text)>(footballChannelNames.entries()),
                func(entry : (Ids.FootballChannelId, Text)) : Bool {
                    Text.startsWith(entry.1, #text searchTerm);
                },
            );

            let droppedEntries = List.drop<(Ids.FootballChannelId, Text)>(filteredEntries, 0); //TODO USE PAGE
            let paginatedEntries = List.take<(Ids.FootballChannelId, Text)>(droppedEntries, 10);

            let channelsBuffer = Buffer.fromArray<FootballChannelQueries.FootballChannel>([]);

            for (entry in Iter.fromList(paginatedEntries)) {
                let channel = await getFootballChannel({ channelId = entry.0 });
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

        public func getFootballChannel(dto : FootballChannelQueries.GetFootballChannel) : async Result.Result<FootballChannelQueries.FootballChannel, Enums.Error> {
            return await getChannel(dto);
        };

        public func getFootballChannelVideos(dto : FootballChannelQueries.GetFootballChannelVideos) : async Result.Result<FootballChannelQueries.FootballChannelVideos, Enums.Error> {
            let existingChannel = await getChannel({ channelId = dto.channelId });

            switch (existingChannel) {
                case (#ok foundChannel) {

                    let footballChannelCanisterId = footballChannelCanisterIndex.get(foundChannel.channelId);
                    switch (footballChannelCanisterId) {
                        case (?foundCanisterId) {
                            let football_channel_canister = actor (foundCanisterId) : actor {
                                updateFootballChannel : (dto : FootballChannelQueries.GetFootballChannelVideos) -> async Result.Result<FootballChannelQueries.FootballChannelVideos, Enums.Error>;
                            };
                            return await football_channel_canister.updateFootballChannel(dto);
                        };
                        case _ {};
                    };
                    return #err(#NotFound);
                };
                case (#err _) { return #err(#NotFound) };
            };
        };

        private func getChannel(dto : FootballChannelQueries.GetFootballChannel) : async Result.Result<FootballChannelQueries.FootballChannel, Enums.Error> {
            let existingFootballChannelCanisterId = footballChannelCanisterIndex.get(dto.channelId);
            switch (existingFootballChannelCanisterId) {
                case (?foundCanisterId) {

                    let footballChannel_canister = actor (foundCanisterId) : actor {
                        getFootballChannel : (dto : FootballChannelQueries.GetFootballChannel) -> async Result.Result<FootballChannelQueries.FootballChannel, Enums.Error>;
                    };

                    return await footballChannel_canister.getFootballChannel({
                        channelId = dto.channelId;
                    });
                };
                case (null) {
                    return #err(#NotFound);
                };
            };
        };

        public func getFootballChannelVideo(dto : FootballChannelQueries.GetFootballChannelVideo) : async Result.Result<FootballChannelQueries.FootballChannelVideo, Enums.Error> {
            let existingFootballChannelCanisterId = footballChannelCanisterIndex.get(dto.channelId);
            switch (existingFootballChannelCanisterId) {
                case (?foundCanisterId) {

                    let footballChannel_canister = actor (foundCanisterId) : actor {
                        getFootballChannelVideo : (dto : FootballChannelQueries.GetFootballChannelVideo) -> async Result.Result<FootballChannelQueries.FootballChannelVideo, Enums.Error>;
                    };

                    return await footballChannel_canister.getFootballChannelVideo({
                        channelId = dto.channelId;
                    });
                };
                case (null) {
                    return #err(#NotFound);
                };
            };
        };
        public func isSubscribed(dto : FootballChannelQueries.IsSubscribed) : async Bool {
            let existingFootballChannelCanisterId = footballChannelCanisterIndex.get(dto.channelId);
            switch (existingFootballChannelCanisterId) {
                case (?foundCanisterId) {

                    let footballChannel_canister = actor (foundCanisterId) : actor {
                        isSubscribed : (dto : FootballChannelQueries.IsSubscribed) -> async Bool;
                    };

                    return await footballChannel_canister.isSubscribed({
                        channelId = dto.channelId;
                        principalId = dto.principalId;
                    });
                };
                case (null) {};
            };
            return false;
        };

        public func createFootballChannel(dto : FootballChannelCommands.CreateFootballChannel) : async Result.Result<Ids.FootballChannelId, Enums.Error> {

            if (Text.size(dto.name) > 100) {
                return #err(#InvalidProperty);
            };

            var football_channel_canister = actor (activeCanisterId) : actor {
                createFootballChannel : (dto : FootballChannelCommands.CreateFootballChannel) -> async Result.Result<Ids.FootballChannelId, Enums.Error>;
                getLatestId : () -> async Ids.FootballChannelId;
                isCanisterFull : () -> async Bool;
            };

            switch (activeCanisterId) {
                case "" {
                    await createNewCanister(totalFootballChannels + 1);
                    football_channel_canister := actor (activeCanisterId) : actor {
                        createFootballChannel : (dto : FootballChannelCommands.CreateFootballChannel) -> async Result.Result<Ids.FootballChannelId, Enums.Error>;
                        getLatestId : () -> async Ids.FootballChannelId;
                        isCanisterFull : () -> async Bool;
                    };
                };
                case _ {
                    let isCanisterFull = await football_channel_canister.isCanisterFull();
                    if (isCanisterFull) {
                        let latestId = await football_channel_canister.getLatestId();
                        let nextId : Ids.FootballChannelId = latestId + 1;
                        await createNewCanister(nextId);
                        football_channel_canister := actor (activeCanisterId) : actor {
                            createFootballChannel : (dto : FootballChannelCommands.CreateFootballChannel) -> async Result.Result<Ids.FootballChannelId, Enums.Error>;
                            getLatestId : () -> async Ids.FootballChannelId;
                            isCanisterFull : () -> async Bool;
                        };
                    };
                };
            };
            return await football_channel_canister.createFootballChannel(dto);
        };
        public func updateFootballChannel(dto : FootballChannelCommands.UpdateFootballChannel) : async Result.Result<(), Enums.Error> {
            let existingChannel = await getChannel({ channelId = dto.channelId });

            switch (existingChannel) {
                case (#ok foundChannel) {

                    let footballChannelCanisterId = footballChannelCanisterIndex.get(foundChannel.channelId);
                    switch (footballChannelCanisterId) {
                        case (?foundCanisterId) {
                            let football_channel_canister = actor (foundCanisterId) : actor {
                                updateFootballChannel : (dto : FootballChannelCommands.UpdateFootballChannel) -> async Result.Result<(), Enums.Error>;
                            };
                            return await football_channel_canister.updateFootballChannel(dto);
                        };
                        case _ {};
                    };
                    return #err(#NotFound);
                };
                case (#err _) { return #err(#NotFound) };
            };
        };

        public func deleteFootballChannel(dto : FootballChannelCommands.DeleteFootballChannel) : async Result.Result<(), Enums.Error> {
            let existingChannel = await getChannel({ channelId = dto.channelId });

            switch (existingChannel) {
                case (#ok foundChannel) {

                    let footballChannelCanisterId = footballChannelCanisterIndex.get(foundChannel.channelId);
                    switch (footballChannelCanisterId) {
                        case (?foundCanisterId) {
                            let football_channel_canister = actor (foundCanisterId) : actor {
                                deleteFootballChannel : (dto : FootballChannelCommands.DeleteFootballChannel) -> async Result.Result<(), Enums.Error>;
                            };
                            return await football_channel_canister.deleteFootballChannel(dto);
                        };
                        case _ {};
                    };
                    return #err(#NotFound);
                };
                case (#err _) { return #err(#NotFound) };
            };
        };

        public func subscribeToFootballChannel(dto : FootballChannelCommands.SubscribeToFootballChannel) : async Result.Result<(), Enums.Error> {
            let existingChannel = await getChannel({ channelId = dto.channelId });

            switch (existingChannel) {
                case (#ok foundChannel) {

                    let footballChannelCanisterId = footballChannelCanisterIndex.get(foundChannel.channelId);
                    switch (footballChannelCanisterId) {
                        case (?foundCanisterId) {
                            let football_channel_canister = actor (foundCanisterId) : actor {
                                subscribeToFootballChannel : (dto : FootballChannelCommands.SubscribeToFootballChannel) -> async Result.Result<(), Enums.Error>;
                            };
                            return await football_channel_canister.subscribeToFootballChannel(dto);
                        };
                        case _ {};
                    };
                    return #err(#NotFound);
                };
                case (#err _) { return #err(#NotFound) };
            };
        };

        public func unsubscribeFromFootballChannel(dto : FootballChannelCommands.UnsubscribeFromFootballChannel) : async Result.Result<(), Enums.Error> {
            let existingChannel = await getChannel({ channelId = dto.channelId });

            switch (existingChannel) {
                case (#ok foundChannel) {

                    let footballChannelCanisterId = footballChannelCanisterIndex.get(foundChannel.channelId);
                    switch (footballChannelCanisterId) {
                        case (?foundCanisterId) {
                            let football_channel_canister = actor (foundCanisterId) : actor {
                                unsubscribeFromFootballChannel : (dto : FootballChannelCommands.UnsubscribeFromFootballChannel) -> async Result.Result<(), Enums.Error>;
                            };
                            return await football_channel_canister.unsubscribeFromFootballChannel(dto);
                        };
                        case _ {};
                    };
                    return #err(#NotFound);
                };
                case (#err _) { return #err(#NotFound) };
            };
        };

        public func uploadFootballChannelVideo(dto : FootballChannelCommands.UploadFootballChannelVideo) : async Result.Result<(), Enums.Error> {
            let existingChannel = await getChannel({ channelId = dto.channelId });

            switch (existingChannel) {
                case (#ok foundChannel) {

                    let footballChannelCanisterId = footballChannelCanisterIndex.get(foundChannel.channelId);
                    switch (footballChannelCanisterId) {
                        case (?foundCanisterId) {
                            let football_channel_canister = actor (foundCanisterId) : actor {
                                uploadFootballChannelVideo : (dto : FootballChannelCommands.UploadFootballChannelVideo) -> async Result.Result<(), Enums.Error>;
                            };
                            return await football_channel_canister.uploadFootballChannelVideo(dto);
                        };
                        case _ {};
                    };
                    return #err(#NotFound);
                };
                case (#err _) { return #err(#NotFound) };
            };
        };

        public func updateFootballChannelVideo(dto : FootballChannelCommands.UpdateFootballChannelVideo) : async Result.Result<(), Enums.Error> {
            let existingChannel = await getChannel({ channelId = dto.channelId });

            switch (existingChannel) {
                case (#ok foundChannel) {

                    let footballChannelCanisterId = footballChannelCanisterIndex.get(foundChannel.channelId);
                    switch (footballChannelCanisterId) {
                        case (?foundCanisterId) {
                            let football_channel_canister = actor (foundCanisterId) : actor {
                                updateFootballChannelVideo : (dto : FootballChannelCommands.UpdateFootballChannelVideo) -> async Result.Result<(), Enums.Error>;
                            };
                            return await football_channel_canister.updateFootballChannelVideo(dto);
                        };
                        case _ {};
                    };
                    return #err(#NotFound);
                };
                case (#err _) { return #err(#NotFound) };
            };
        };

        public func removeFootballChannelVideo(dto : FootballChannelCommands.RemoveFootballChannelVideo) : async Result.Result<(), Enums.Error> {
            let existingChannel = await getChannel({ channelId = dto.channelId });

            switch (existingChannel) {
                case (#ok foundChannel) {

                    let footballChannelCanisterId = footballChannelCanisterIndex.get(foundChannel.channelId);
                    switch (footballChannelCanisterId) {
                        case (?foundCanisterId) {
                            let football_channel_canister = actor (foundCanisterId) : actor {
                                removeFootballChannelVideo : (dto : FootballChannelCommands.RemoveFootballChannelVideo) -> async Result.Result<(), Enums.Error>;
                            };
                            return await football_channel_canister.removeFootballChannelVideo(dto);
                        };
                        case _ {};
                    };
                    return #err(#NotFound);
                };
                case (#err _) { return #err(#NotFound) };
            };
        };

        public func isChannelOwner(dto : FootballChannelQueries.IsChannelOwner) : async Bool {
            let existingChannel = await getChannel({ channelId = dto.channelId });

            switch (existingChannel) {
                case (#ok foundChannel) {

                    let footballChannelCanisterId = footballChannelCanisterIndex.get(foundChannel.channelId);
                    switch (footballChannelCanisterId) {
                        case (?foundCanisterId) {
                            let football_channel_canister = actor (foundCanisterId) : actor {
                                isChannelOwner : (dto : FootballChannelQueries.IsChannelOwner) -> async Bool;
                            };
                            return await football_channel_canister.isChannelOwner(dto);
                        };
                        case _ {};
                    };
                };
                case (#err _) {};
            };
            return false;
        };

        //stable storage getters and setters

        public func getStableCanisterIndex() : [(Ids.FootballChannelId, Ids.CanisterId)] {
            return Iter.toArray(footballChannelCanisterIndex.entries());
        };

        public func setStableCanisterIndex(stable_football_channel_canister_index : [(Ids.FootballChannelId, Ids.CanisterId)]) {
            let canisterIds : TrieMap.TrieMap<Ids.FootballChannelId, Ids.CanisterId> = TrieMap.TrieMap<Ids.FootballChannelId, Ids.CanisterId>(BaseUtilities.eqNat, BaseUtilities.hashNat);

            for (canisterId in Iter.fromArray(stable_football_channel_canister_index)) {
                canisterIds.put(canisterId);
            };
            footballChannelCanisterIndex := canisterIds;
        };

        public func getStableActiveCanisterId() : Ids.CanisterId {
            return activeCanisterId;
        };

        public func setStableActiveCanisterId(stable_active_canister_id : Ids.CanisterId) {
            activeCanisterId := stable_active_canister_id;
        };

        public func getStableFootballChannelNames() : [(Ids.FootballChannelId, Text)] {
            return Iter.toArray(footballChannelNames.entries());
        };

        public func setStableFootballChannelNames(stable_channel_names : [(Ids.FootballChannelId, Text)]) : () {
            let football_channel_map : TrieMap.TrieMap<Ids.FootballChannelId, Ids.CanisterId> = TrieMap.TrieMap<Ids.FootballChannelId, Ids.CanisterId>(BaseUtilities.eqNat, BaseUtilities.hashNat);

            for (channelName in Iter.fromArray(stable_channel_names)) {
                football_channel_map.put(channelName);
            };
            footballChannelNames := football_channel_map;
        };

        public func getStableUniqueCanisterIds() : [Ids.CanisterId] {
            return List.toArray(uniqueFootballChannelCanisterIds);
        };

        public func setStableUniqueCanisterIds(stable_unique_canister_ids : [Ids.CanisterId]) : () {
            let canisterIdBuffer = Buffer.fromArray<Ids.CanisterId>([]);

            for (canisterId in Iter.fromArray(stable_unique_canister_ids)) {
                canisterIdBuffer.add(canisterId);
            };
            uniqueFootballChannelCanisterIds := List.fromArray(Buffer.toArray(canisterIdBuffer));
        };

        public func getStableTotalFootballChannels() : Nat {
            return totalFootballChannels;
        };

        public func setStableTotalFootballChannels(stable_total_football_channels : Nat) : () {
            totalFootballChannels := stable_total_football_channels;
        };

        public func getStableNextFootballChannelId() : Ids.FootballChannelId {
            return nextFootballChannelId;
        };

        public func setStableNextFootballChannelId(stable_next_football_channel_id : Ids.FootballChannelId) : () {
            nextFootballChannelId := stable_next_football_channel_id;
        };

        //TODO WHEN?!

        private func createNewCanister(nextId : Ids.FootballChannelId) : async () {
            Cycles.add<system>(10_000_000_000_000);
            let canister = await FootballChannelsCanister._FootballChannelsCanister();
            let IC : Management.Management = actor (CanisterIds.Default);
            let principal = ?Principal.fromText(CanisterIds.ICFC_BACKEND_CANISTER_ID);
            let _ = await CanisterUtilities.updateCanister_(canister, principal, IC);

            let canister_principal = Principal.fromActor(canister);
            let canisterId = Principal.toText(canister_principal);

            if (canisterId == "") {
                return;
            };

            var new_canister = actor (canisterId) : actor {
                updateNextId : (nextId : Ids.FootballChannelId) -> async ();
            };

            await new_canister.updateNextId(nextId);

            let uniqueCanisterIdBuffer = Buffer.fromArray<Ids.CanisterId>(List.toArray(uniqueFootballChannelCanisterIds));
            uniqueCanisterIdBuffer.add(canisterId);
            uniqueFootballChannelCanisterIds := List.fromArray(Buffer.toArray(uniqueCanisterIdBuffer));
            activeCanisterId := canisterId;
            return;
        };
    };

};
