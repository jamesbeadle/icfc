module SaleTypes {
    public type ClaimedRecord = {
        packetsClaimed : Nat;
        claimedOn : Int;
        membershipType : MembershipType;
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
        #InsufficientPacketsRemaining;
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
