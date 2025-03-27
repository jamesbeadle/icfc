import Base "mo:waterway-mops/BaseTypes";
import Time "mo:base/Time";
module SaleTypes {
    type Subaccount = Blob;
    type Tokens = Nat;
    type Timestamp = Nat64;
    type BlockIndex = Nat;

    public type ClaimedRecord = {
        packetsClaimed : Nat;
        claimedOn : Int;
        claimId : Int;
    };

    public type TransferError = {
        #BadFee : { expected_fee : Tokens };
        #BadBurn : { min_burn_amount : Tokens };
        #InsufficientFunds : { balance : Tokens };
        #TooOld;
        #CreatedInFuture : { ledger_time : Timestamp };
        #TemporarilyUnavailable;
        #Duplicate : { duplicate_of : BlockIndex };
        #GenericError : { error_code : Nat; message : Text };
    };

    public type TransferResult = {
        #Ok : BlockIndex;
        #Err : TransferError;
    };

    public type ICFCDistribution = {
        principalId : Base.PrincipalId;
        amount : Nat;
        time : Time.Time;
        claimId : Nat;
        installment : Nat;
        distributionStatus : DistributionStatus;
    };

    public type DistributionStatus = {
        #Pending;
        #Completed;
    };
    public type Account = {
        owner : Principal;
        subaccount : ?Subaccount;
    };
    public type TransferArg = {
        from_subaccount : ?Subaccount;
        to : Account;
        amount : Tokens;
        fee : ?Tokens;
        memo : ?Blob;
        created_at_time : ?Timestamp;
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
