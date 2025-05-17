import Ids "mo:waterway-mops/base/ids";

import AppIds "../ids";

module FootballChannelCommands {

    public type CreateFootballChannel = {
        createdById: Ids.PrincipalId;
        name: Text;
    };

    public type UpdateFootballChannel = {
        channelId: AppIds.FootballChannelId;
        name: Text;
        channelImage: ?Blob;
        channelImageExtension: Text;
        channelBanner: ?Blob;
        channelBannerExtension: Text;
    };

    public type DeleteFootballChannel = {
        channelId: AppIds.FootballChannelId;
    };

    public type SubscribeToFootballChannel = {
        principalId: Ids.PrincipalId;
        channelId: AppIds.FootballChannelId;
    };

    public type UnsubscribeFromFootballChannel = {
        principalId: Ids.PrincipalId;
        channelId: AppIds.FootballChannelId;
    };

    public type UploadFootballChannelVideo = {
        channelId: AppIds.FootballChannelId;
    };

    public type UpdateFootballChannelVideo = {
        channelId: AppIds.FootballChannelId;
    };

    public type RemoveFootballChannelVideo = {
        channelId: AppIds.FootballChannelId;
    };

}

  