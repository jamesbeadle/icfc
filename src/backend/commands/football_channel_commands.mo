import Ids "mo:waterway-mops/Ids";

module FootballChannelCommands {

    public type CreateFootballChannel = {
        createdById: Ids.PrincipalId;
        name: Text;
    };

    public type UpdateFootballChannel = {
        channelId: Ids.FootballChannelId;
        name: Text;
        channelImage: ?Blob;
        channelImageExtension: Text;
        channelBanner: ?Blob;
        channelBannerExtension: Text;
    };

    public type DeleteFootballChannel = {
        channelId: Ids.FootballChannelId;

    };

    public type SubscribeToFootballChannel = {
        principalId: Ids.PrincipalId;
        channelId: Ids.FootballChannelId;

    };

    public type UnsubscribeFromFootballChannel = {
        principalId: Ids.PrincipalId;
        channelId: Ids.FootballChannelId;

    };

    public type UploadFootballChannelVideo = {
        channelId: Ids.FootballChannelId;

    };

    public type UpdateFootballChannelVideo = {
        channelId: Ids.FootballChannelId;

    };

    public type RemoveFootballChannelVideo = {
        channelId: Ids.FootballChannelId;

    };

}

  