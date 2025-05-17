import Ids "mo:waterway-mops/base/ids";

import T "../types";

module AppQueries {

    public type AppStatus = {
        onHold : Bool;
        version : Text;
    };

    public type Profile = {
        principalId: Ids.PrincipalId;
        username: Text;
        displayName: Text;
        subscriptionType: ICFCEnums.SubscriptionType;
        subscriptions: [T.Subscription];
        createdOn: Int;
        profilePicture: Blob;
        termsAgreed: Bool;
        unconfirmedAppPrincipalIds: [(Text, Ids.PrincipalId)];
        appPrincipalIds: [(Text, Ids.PrincipalId)];
    };

    public type TokenBalances = {
        icpBalance : Nat;
        icfcBalance : Nat;
        ckBTCBalance : Nat;
        icgcBalance : Nat;
    };

}

  