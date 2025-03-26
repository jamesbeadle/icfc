module SaleTypes {
    public type SaleParticipant = {
        user : Principal;
        amount : Nat;
        icfc_staked : Float;
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
