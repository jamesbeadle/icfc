import Base "mo:waterway-mops/BaseTypes";

module GolferCommands {

    public type CreateProfile = {
        username : Text;
        profilePicture : ?Blob;
        profilePictureExtension : ?Text;
        displayName : Text;
    };

    public type UpdateUserName = {
        principalId : Base.PrincipalId;
        username : Text;
    };


    public type UpdateProfilePicture = {
        principalId : Base.PrincipalId;
        profilePicture : ?Blob;
        profilePictureExtension : Text;
    };

    public type DeleteProfile = {
        principalId : Base.PrincipalId;
        confirm : Bool;
    };
};
