module SaleTypes {
    public type SaleParticipant = {
        user : Principal;
        icfc_staked : Nat;
        time : Nat64;
    };

    public type Error = {
        #NotFound;
        #AlreadyExists;
        #NotAuthorized;
        #NotAllowed;
        #DecodeError;
        #InvalidData;
        #OutOfRange;
        #NotEnoughFunds;
        #PaymentError;
        #CreateGameError;
        #UpdateFailed;
        #AlreadyClaimed;
        #NoPacketsRemaining;
        #NotEligible;
    };

    public type MembershipType = {
        #Monthly;
        #Seasonal;
        #Lifetime;
        #Founding;
        #Expired;
        #NotClaimed;
        #NotEligible;
    };

    public type MembershipClaim = {
        membershipType : MembershipType;
        claimedOn : Int;
        expiresOn : ?Int;
    };
};
