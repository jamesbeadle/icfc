export const idlFactory = ({ IDL }) => {
  const Error = IDL.Variant({
    InvalidProfilePicture: IDL.Null,
    DecodeError: IDL.Null,
    TooLong: IDL.Null,
    NotAllowed: IDL.Null,
    DuplicateData: IDL.Null,
    InvalidProperty: IDL.Null,
    NotFound: IDL.Null,
    IncorrectSetup: IDL.Null,
    AlreadyClaimed: IDL.Null,
    NotAuthorized: IDL.Null,
    MaxDataExceeded: IDL.Null,
    InvalidData: IDL.Null,
    SystemOnHold: IDL.Null,
    AlreadyExists: IDL.Null,
    NoPacketsRemaining: IDL.Null,
    UpdateFailed: IDL.Null,
    CanisterCreateError: IDL.Null,
    NeuronAlreadyUsed: IDL.Null,
    FailedInterCanisterCall: IDL.Null,
    InsufficientPacketsRemaining: IDL.Null,
    InsufficientFunds: IDL.Null,
    InEligible: IDL.Null,
  });
  const Result_4 = IDL.Variant({ ok: IDL.Null, err: Error });
  const AppStatus = IDL.Record({ version: IDL.Text, onHold: IDL.Bool });
  const Result_3 = IDL.Variant({ ok: AppStatus, err: Error });
  const SaleProgress = IDL.Record({
    remainingPacks: IDL.Nat,
    packCostinICP: IDL.Nat,
    totalPacks: IDL.Nat,
  });
  const Result_2 = IDL.Variant({ ok: SaleProgress, err: Error });
  const PurchaseRecord = IDL.Record({
    purchasedOn: IDL.Int,
    packsPurchased: IDL.Nat,
    purchaseId: IDL.Nat,
  });
  const UserParticipation = IDL.Record({
    participations: IDL.Vec(PurchaseRecord),
  });
  const Result_1 = IDL.Variant({ ok: UserParticipation, err: Error });
  const Time = IDL.Int;
  const DistributionStatus = IDL.Variant({
    Completed: IDL.Null,
    Pending: IDL.Null,
  });
  const PrincipalId = IDL.Text;
  const ICFCDistribution = IDL.Record({
    time: Time,
    installment: IDL.Nat,
    distributionStatus: DistributionStatus,
    purchaseId: IDL.Nat,
    amount: IDL.Nat,
    principalId: PrincipalId,
  });
  const Result = IDL.Variant({
    ok: IDL.Vec(ICFCDistribution),
    err: Error,
  });
  const Self = IDL.Service({
    claimICFCPacks: IDL.Func([], [Result_4], []),
    getAppStatus: IDL.Func([], [Result_3], ["query"]),
    getProgress: IDL.Func([], [Result_2], []),
    getUserParticipation: IDL.Func([], [Result_1], []),
    getUsersICFCDistributions: IDL.Func([], [Result], []),
  });
  return Self;
};
export const init = ({ IDL }) => {
  return [];
};
