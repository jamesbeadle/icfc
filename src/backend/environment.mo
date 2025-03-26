import Nat64 "mo:base/Nat64";
module Environment {
  public let DFX_NETWORK = "ic";
  public let Default = "aaaaa-aa";
  public let CYCLES_MINTING_CANISTER_ID = "rkp4c-7iaaa-aaaaa-aaaca-cai";
  public let ICP_COINS_CANISTER_ID = "u45jl-liaaa-aaaam-abppa-cai";
  public let NNS_GOVERNANCE_CANISTER_ID = "rrkah-fqaaa-aaaaa-aaaaq-cai";
  public let NNS_LEDGER_CANISTER_ID = "ryjl3-tyaaa-aaaaa-aaaba-cai";
  public let BACKEND_CANISTER_ID = "cfalf-4yaaa-aaaal-qshrq-cai";
  public let FRONTEND_CANISTER_ID = "cqh2i-5qaaa-aaaal-qshsa-cai";
  public let SNS_GOVERNANCE_CANISTER_ID = "detjl-sqaaa-aaaaq-aacqa-cai";
  public let SNS_LEDGER_CANISTER_ID = "ddsp7-7iaaa-aaaaq-aacqq-cai";
  public let CKBTC_LEDGER_CANISTER_ID = "mxzaz-hqaaa-aaaar-qaada-cai";

  public let ICFC_SALE_2_CANISTER_ID = "fiex2-wyaaa-aaaal-qslmq-cai";

  // SubApps canister IDs
  public let FOOTBALL_GOD_BACKEND_CANISTER_ID = "44kin-waaaa-aaaal-qbxra-cai";
  public let OPENFPL_BACKEND_CANISTER_ID = "y22zx-giaaa-aaaal-qmzpq-cai";
  public let OPENWSL_BACKEND_CANISTER_ID = "5bafg-ayaaa-aaaal-qmzqq-cai";
  public let JEFF_BETS_BACKEND_CANISTER_ID = "cmdaz-kqaaa-aaaal-qshqa-cai";
  public let TRANSFERKINGS_CANISTER_ID = "fpmh5-ziaaa-aaaal-qjfbq-cai";

  public let ADMIN_PRINCIPALS = [
    "", //JB
    "pbubx-wqioh-kaji3-tjvfv-2s3j3-wn3xw-fs5lm-jmoap-yddfv-vzwgl-5qe", //JBN local
  ];

  public let OWNER_PRINCIPAL = ""; //JB

  public let PODCAST_CHARGE = 1;
  public let PODCAST_FEE = 0.1; // 10%
  public let PODCAST_GRADUATION = 10000;
};
