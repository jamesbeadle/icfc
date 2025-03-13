import Nat64 "mo:base/Nat64";
module Environment {
  public let DFX_NETWORK = "ic";
  public let Default = "aaaaa-aa";
  public let CYCLES_MINTING_CANISTER_ID = "rkp4c-7iaaa-aaaaa-aaaca-cai";
  public let ICP_COINS_CANISTER_ID = "u45jl-liaaa-aaaam-abppa-cai";
  public let NNS_GOVERNANCE_CANISTER_ID = "rrkah-fqaaa-aaaaa-aaaaq-cai";
  public let NNS_LEDGER_CANISTER_ID = "ryjl3-tyaaa-aaaaa-aaaba-cai";
  public let BACKEND_CANISTER_ID = "clcgn-hiaaa-aaaal-qshqq-cai";
  public let FRONTEND_CANISTER_ID = "cqh2i-5qaaa-aaaal-qshsa-cai";
  public let SNS_GOVERNANCE_CANISTER_ID = "detjl-sqaaa-aaaaq-aacqa-cai";

  public let ADMIN_PRINCIPALS = [
    "", //JB
    "pbubx-wqioh-kaji3-tjvfv-2s3j3-wn3xw-fs5lm-jmoap-yddfv-vzwgl-5qe", //JBN local
  ];

  public let OWNER_PRINCIPAL = ""; //JB

  public let PODCAST_CHARGE = 1;
  public let PODCAST_FEE = 0.1; // 10%
  public let PODCAST_GRADUATION = 10000;
  public let CKBTC_MIN_GOAL = 50;
  public let CKBTC_MAX_GOAL = 100;
  public let SALE_START : Nat64 = 1743465600000000000;
  public let SALE_END : Nat64 = 1746057600000000000;
  public let ICFC_MONTHLY_MEMBERSHIP_FEE = 5;
  public let ICFC_ANNUAL_MEMBERSHIP_FEE = 50;
  public let ICFC_LIFETIME_MEMBERSHIP_FEE = 500;
};
