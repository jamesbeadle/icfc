import T "../icfc_types";
import Base "mo:waterway-mops/BaseTypes";

module FootballChannelQueries {

    public type GetFootballChannels = {
        principalId : Base.PrincipalId;
        page : Nat;
        searchTerm : Text;

    };

    public type FootballChannels = {
        entries : [FootballChannel];
        page : Nat;
        total : Nat;
        pageSize : Nat;
    };

    public type GetFootballChannel = {
        channelId : T.FootballChannelId;
    };

    public type FootballChannel = {
        name : Text;
        channelId : T.FootballChannelId;
    };

    public type GetFootballChannelVideos = {
        channelId : T.FootballChannelId;
        page : Nat;
    };

    public type FootballChannelVideos = {
        channelId : T.FootballChannelId;
    };

    public type GetFootballChannelVideo = {
        channelId : T.FootballChannelId;
    };

    public type FootballChannelVideo = {
        channelId : T.FootballChannelId;
    };

    public type IsChannelOwner = {
        principalId : Base.PrincipalId;
        channelId : T.FootballChannelId;
    };

    public type IsSubscribed = {
        principalId : Base.PrincipalId;
        channelId : T.FootballChannelId;
    };

};
