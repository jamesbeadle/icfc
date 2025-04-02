import Ids "mo:waterway-mops/Ids";
module = {
    public type GetICFCMembership = {
        principalId : Ids.PrincipalId;
    };

    public type ParticipateInSale = {
        principalId : Ids.PrincipalId;
    };
    public type RefreshParticipant = {
        principalId : Ids.PrincipalId;
    };

};
