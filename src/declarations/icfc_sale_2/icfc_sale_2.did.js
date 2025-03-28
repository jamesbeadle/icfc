export const idlFactory = ({ IDL }) => {
  const CalimICFCPackets = IDL.Record({ packets: IDL.Nat });
  const Error = IDL.Variant({
    DecodeError: IDL.Null,
    NotAllowed: IDL.Null,
    NotEnoughFunds: IDL.Null,
    NotFound: IDL.Null,
    AlreadyClaimed: IDL.Null,
    NotAuthorized: IDL.Null,
    InvalidData: IDL.Null,
    AlreadyExists: IDL.Null,
    NoPacketsRemaining: IDL.Null,
    CreateGameError: IDL.Null,
    UpdateFailed: IDL.Null,
    NotEligible: IDL.Null,
    OutOfRange: IDL.Null,
    PaymentError: IDL.Null,
    InsufficientPacketsRemaining: IDL.Null,
  });
  const Result_4 = IDL.Variant({ ok: IDL.Null, err: Error });
  const AppStatusDTO = IDL.Record({
    version: IDL.Text,
    onHold: IDL.Bool,
  });
  const Result_3 = IDL.Variant({ ok: AppStatusDTO, err: Error });
  const SaleProgressDTO = IDL.Record({
    remainingPackets: IDL.Nat,
    totalPackets: IDL.Nat,
  });
  const Result_2 = IDL.Variant({ ok: SaleProgressDTO, err: Error });
  const ClaimedRecord = IDL.Record({
    packetsClaimed: IDL.Nat,
    claimId: IDL.Int,
    claimedOn: IDL.Int,
  });
  const UserParticipationDTO = IDL.Record({
    participations: IDL.Vec(ClaimedRecord),
  });
  const Result_1 = IDL.Variant({ ok: UserParticipationDTO, err: Error });
  const Time = IDL.Int;
  const DistributionStatus = IDL.Variant({
    Completed: IDL.Null,
    Pending: IDL.Null,
  });
  const PrincipalId = IDL.Text;
  const ICFCDistribution = IDL.Record({
    time: Time,
    claimId: IDL.Nat,
    installment: IDL.Nat,
    distributionStatus: DistributionStatus,
    amount: IDL.Nat,
    principalId: PrincipalId,
  });
  const Result = IDL.Variant({
    ok: IDL.Vec(ICFCDistribution),
    err: Error,
  });
  const Self = IDL.Service({
    claimICFCPackets: IDL.Func([CalimICFCPackets], [Result_4], []),
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
