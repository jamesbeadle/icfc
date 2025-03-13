import Base "mo:waterway-mops/BaseTypes";

module ProfileQueries {
    public type GetProfile = {
        principalId : Base.PrincipalId;
    };

    public type Profile = {
        principalId : Base.PrincipalId;
        username : Text;
        profilePicture : ?Blob;
        profilePictureExtension : Text;
    };



    public type ListProfiles = {
        searchTerm : Text;
        totalEntries : Nat;
        limit : Nat;
        offset : Nat;
    };

    public type Profiles = {
        profiles : [ProfileSummary];
    };

    public type ProfileSummary = {
        profilePrincipalId : Base.PrincipalId;
        userName : Text;
        userPicture : ?Blob;
        userPictureExtension : Text;
    };

    public type IsUsernameAvailable = {
        username : Text;
        principalId : Base.PrincipalId;
    };

    public type UsernameAvailable = Bool;

};
