import AppIds "../Ids";
import Ids "mo:waterway-mops/base/ids";

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
        channelId : AppIds.FootballChannelId;
    };

    public type FootballChannel = {
        name : Text;
        channelId : AppIds.FootballChannelId;
    };

    public type GetFootballChannelVideos = {
        channelId : AppIds.FootballChannelId;
        page : Nat;
    };

    public type FootballChannelVideos = {
        channelId : AppIds.FootballChannelId;
    };

    public type GetFootballChannelVideo = {
        channelId : AppIds.FootballChannelId;
    };

    public type FootballChannelVideo = {
        channelId : AppIds.FootballChannelId;
    };

    public type IsChannelOwner = {
        principalId : Ids.PrincipalId;
        channelId : AppIds.FootballChannelId;
    };

    public type IsSubscribed = {
        principalId : Ids.PrincipalId;
        channelId : AppIds.FootballChannelId;
    };

};
