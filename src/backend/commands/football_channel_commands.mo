
import T "../icfc_types";
import Base "mo:waterway-mops/BaseTypes";

module FootballChannelCommands {

    public type CreateFootballChannel = {
        createdById: Base.PrincipalId;
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
        principalId: Base.PrincipalId;
        channelId: T.FootballChannelId;

    };

    public type UnsubscribeFromFootballChannel = {
        principalId: Base.PrincipalId;
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

  