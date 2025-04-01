
import T "../icfc_types";
import Ids "mo:waterway-mops/Ids";

module FootballChannelCommands {

    public type CreateFootballChannel = {
        createdById: Ids.PrincipalId;
        name: Text;
    };

    public type UpdateFootballChannel = {
        channelId: T.FootballChannelId;
        name: Text;
        channelImage: ?Blob;
        channelImageExtension: Text;
        channelBanner: ?Blob;
        channelBannerExtension: Text;
    };

    public type DeleteFootballChannel = {
        channelId: T.FootballChannelId;

    };

    public type SubscribeToFootballChannel = {
        principalId: Ids.PrincipalId;
        channelId: T.FootballChannelId;

    };

    public type UnsubscribeFromFootballChannel = {
        principalId: Ids.PrincipalId;
        channelId: T.FootballChannelId;

    };

    public type UploadFootballChannelVideo = {
        channelId: T.FootballChannelId;

    };

    public type UpdateFootballChannelVideo = {
        channelId: T.FootballChannelId;

    };

    public type RemoveFootballChannelVideo = {
        channelId: T.FootballChannelId;

    };

}

  