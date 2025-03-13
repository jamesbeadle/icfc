import T "../icfc_types";
import Base "mo:waterway-mops/BaseTypes";

module PodcastChannelQueries {

    public type GetPodcastChannels = {
        principalId : Base.PrincipalId;
        page : Nat;
        searchTerm : Text;

    };

    public type PodcastChannels = {
        entries : [PodcastChannel];
        page : Nat;
        total : Nat;
        pageSize : Nat;
    };

    public type GetPodcastChannel = {
        channelId : T.PodcastChannelId;
    };

    public type PodcastChannel = {
        name : Text;
        channelId : T.PodcastChannelId;
    };

    public type GetPodcastChannelVideos = {
        channelId : T.PodcastChannelId;
        page : Nat;
    };

    public type PodcastChannelVideos = {
        channelId : T.PodcastChannelId;
    };

    public type GetPodcastChannelVideo = {
        channelId : T.PodcastChannelId;
    };

    public type PodcastChannelVideo = {
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
