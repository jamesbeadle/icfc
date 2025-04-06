import Ids "mo:waterway-mops/Ids";
import Time "mo:base/Time";
module SaleTypes {
    type Subaccount = Blob;
    type Tokens = Nat;
    type Timestamp = Nat64;
    type BlockIndex = Nat;

    public type PurchaseRecord = {
        packsPurchased : Nat;
        purchasedOn : Int;
        purchaseId : Nat;
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
        principalId : Ids.PrincipalId;
        amount : Nat;
        time : Time.Time;
        purchaseId : Nat;
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
        purchasedOn : Int;
        expiresOn : ?Int;
    };

    public type Error = {
        #AlreadyClaimed;
        #AlreadyExists;
        #CanisterCreateError;
        #DecodeError;
        #DuplicateData;
        #FailedInterCanisterCall;
        #InEligible;
        #IncorrectSetup;
        #InsufficientFunds;
        #InsufficientPacketsRemaining; // TODO Packs
        #InvalidData;
        #InvalidProfilePicture;
        #InvalidProperty;
        #MaxDataExceeded;
        #NeuronAlreadyUsed;
        #NoPacketsRemaining;  // TODO Packs
        #NotAllowed;
        #NotAuthorized;
        #NotFound;
        #SystemOnHold;
        #TooLong;
        #UpdateFailed
    };
};
