import T "../icfc_types";
import Base "mo:waterway-mops/BaseTypes";

module PodcastChannelQueries {

    public type GetPodcastChannels = {
        limit : Nat;
        offset : Nat;
        searchTerm : Text;
    };

    public type PodcastChannels = {

    };

    public type GetPodcastChannel = {
        channelId : T.PodcastChannelId;
    };

    public type PodcastChannel = {
        name : Text;
        channelId : T.PodcastChannelId;
    };

    public type GetGolfChannelVideos = {
        channelId : T.PodcastChannelId;
        page : Nat;
    };

    public type GolfChannelVideos = {
        channelId : T.PodcastChannelId;
    };

    public type GetGolfChannelVideo = {
        channelId : T.PodcastChannelId;
    };

    public type GolfChannelVideo = {
        channelId : T.PodcastChannelId;
    };

    public type IsChannelOwner = {
        principalId : Base.PrincipalId;
        channelId : T.PodcastChannelId;
    };

    public type IsSubscribed = {
        principalId : Base.PrincipalId;
        channelId : T.PodcastChannelId;
    };

};
