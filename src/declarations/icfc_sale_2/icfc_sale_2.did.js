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
  const Result_3 = IDL.Variant({ ok: IDL.Null, err: Error });
  const AppStatusDTO = IDL.Record({
    version: IDL.Text,
    onHold: IDL.Bool,
  });
  const Result_2 = IDL.Variant({ ok: AppStatusDTO, err: Error });
  const MembershipType = IDL.Variant({
    Founding: IDL.Null,
    NotClaimed: IDL.Null,
    Seasonal: IDL.Null,
    Lifetime: IDL.Null,
    Monthly: IDL.Null,
    NotEligible: IDL.Null,
    Expired: IDL.Null,
  });
  const ClaimedRecord = IDL.Record({
    packetsClaimed: IDL.Nat,
    claimedOn: IDL.Int,
    membershipType: MembershipType,
  });
  const UserParticipationDTO = IDL.Record({
    participations: IDL.Vec(ClaimedRecord),
  });
  const Result_1 = IDL.Variant({ ok: UserParticipationDTO, err: Error });
  const SaleProgressDTO = IDL.Record({
    remainingPackets: IDL.Nat,
    totalPackets: IDL.Nat,
  });
  const Result = IDL.Variant({ ok: SaleProgressDTO, err: Error });
  const Self = IDL.Service({
    claimICFCPackets: IDL.Func([CalimICFCPackets], [Result_3], []),
    getAppStatus: IDL.Func([], [Result_2], ["query"]),
    getUserParticipation: IDL.Func([], [Result_1], []),
    get_progress: IDL.Func([], [Result], []),
  });
  return Self;
};
export const init = ({ IDL }) => {
  return [];
};
