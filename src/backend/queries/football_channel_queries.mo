import Ids "mo:waterway-mops/Ids";

module FootballChannelQueries {

    public type GetFootballChannels = {
        principalId : Ids.PrincipalId;
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
        channelId : Ids.FootballChannelId;
    };

    public type FootballChannel = {
        name : Text;
        channelId : Ids.FootballChannelId;
    };

    public type GetFootballChannelVideos = {
        channelId : Ids.FootballChannelId;
        page : Nat;
    };

    public type FootballChannelVideos = {
        channelId : Ids.FootballChannelId;
    };

    public type GetFootballChannelVideo = {
        channelId : Ids.FootballChannelId;
    };

    public type FootballChannelVideo = {
        channelId : Ids.FootballChannelId;
    };

    public type IsChannelOwner = {
        principalId : Ids.PrincipalId;
        channelId : Ids.FootballChannelId;
    };

    public type IsSubscribed = {
        principalId : Ids.PrincipalId;
        channelId : Ids.FootballChannelId;
    };

};
