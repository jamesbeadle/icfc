
import T "../icfc_types";
import Base "mo:waterway-mops/BaseTypes";

module PodcastChannelCommands {

    public type CreatePodcastChannel = {
        createdById: Base.PrincipalId;
        name: Text;
    };

    public type UpdatePodcastChannel = {
        channelId: T.PodcastChannelId;
        name: Text;
        channelImage: ?Blob;
        channelImageExtension: Text;
        channelBanner: ?Blob;
        channelBannerExtension: Text;
    };

    public type DeletePodcastChannel = {
        channelId: T.PodcastChannelId;

    };

    public type SubscribeToPodcastChannel = {
        principalId: Base.PrincipalId;
        channelId: T.PodcastChannelId;

    };

    public type UnsubscribeFromPodcastChannel = {
        principalId: Base.PrincipalId;
        channelId: T.PodcastChannelId;

    };

    public type UploadPodcastChannelVideo = {
        channelId: T.PodcastChannelId;

    };

    public type UpdatePodcastChannelVideo = {
        channelId: T.PodcastChannelId;

    };

    public type RemovePodcastChannelVideo = {
        channelId: T.PodcastChannelId;

    };

}

  