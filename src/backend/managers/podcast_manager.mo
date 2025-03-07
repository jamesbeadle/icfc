import Principal "mo:base/Principal";
import TrieMap "mo:base/TrieMap";
import Timer "mo:base/Timer";
import Time "mo:base/Time";
import Result "mo:base/Result";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import ICFCTypes "../icfc_types";
import Environment "../environment";

module {
    public class PodcastManager() {

        private var podcastEntries : [(Principal, ICFCTypes.Podcast)] = [];
        private let podcasts = TrieMap.fromEntries<Principal, ICFCTypes.Podcast>(
            podcastEntries.vals(),
            Principal.equal,
            Principal.hash,
        );

        private var graduationThreshold : Nat = Environment.PODCAST_GRADUATION;

        // private let timerId = Timer.recurringTimer<system>(
        //     #seconds(2_592_000), // 30 days
        //     monthlyFeeCollection
        // );

        public func createPodcast(
            caller : Principal,
            name : Text,
            description : Text,
            subscriptionFee : Nat,
        ) : async Result.Result<Text, ICFCTypes.Error> {
            let podcastId = Principal.toText(caller) # "-" # Nat.toText(Int.abs(Time.now()));
            let podcast : ICFCTypes.Podcast = {
                id = podcastId;
                name = name;
                description = description;
                createdOn = Time.now();
                creator = Principal.toText(caller);
                members = [];
                subscriptionFee = subscriptionFee;
                totalRevenue = 0;
                isGraduated = false;
            };
            podcasts.put(caller, podcast);
            return #ok(podcastId);

        };

        public func subscribe(caller : Principal, podcastId : Principal) : async Result.Result<(), ICFCTypes.Error> {
            switch (podcasts.get(podcastId)) {
                case (null) {
                    #err(#NotFound);
                };
                case (?podcast) {
                    let callerId = Principal.toText(caller);
                    if (Array.find(podcast.members, func(m : Text) : Bool { m == callerId }) != null) {
                        return #err(#AlreadyExists);
                    };
                    let membersBuffer = Buffer.fromArray<Text>(podcast.members);
                    membersBuffer.add(callerId);
                    let updatedMembers = Buffer.toArray(membersBuffer);
                   
                    podcasts.put(
                        podcastId,
                        {
                            podcast with members = updatedMembers;
                        },
                    );
                    return #ok(());
                };
            };
        };

        public func unsubscribe(caller: Principal, podcastId:Principal): async Result.Result<(), ICFCTypes.Error>{
            switch (podcasts.get(podcastId)) {
                case (null) {
                    #err(#NotFound);
                };
                case (?podcast) {
                    let callerId = Principal.toText(caller);
            
                    let updatedMembers = Array.filter(podcast.members, func(m : Text) : Bool { m != callerId });
                    podcasts.put(
                        podcastId,
                        {
                            podcast with members = updatedMembers;
                        },
                    );
                    return #ok(());
                };
            };
        };

        private func monthlyFeeCollection():async (){
            for((podcastId,podcast) in podcasts.entries()){
                let fee = podcast.subscriptionFee;
                let creatorAccount = {owner = Principal.fromText(podcast.creator); subaccount = null};
            }
        }

    };
};
