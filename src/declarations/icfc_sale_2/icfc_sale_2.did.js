export const idlFactory = ({ IDL }) => {
  const AppStatusDTO = IDL.Record({
    version: IDL.Text,
    onHold: IDL.Bool,
  });
  const Error = IDL.Variant({
    DecodeError: IDL.Null,
    NotAllowed: IDL.Null,
    NotEnoughFunds: IDL.Null,
    NotFound: IDL.Null,
    AlreadyClaimed: IDL.Null,
    NotAuthorized: IDL.Null,
    InvalidData: IDL.Null,
    AlreadyExists: IDL.Null,
    CreateGameError: IDL.Null,
    UpdateFailed: IDL.Null,
    OutOfRange: IDL.Null,
    PaymentError: IDL.Null,
  });
  const Result_3 = IDL.Variant({ ok: AppStatusDTO, err: Error });
  const SaleGoalDTO = IDL.Record({
    goal: IDL.Nat,
    currentProgress: IDL.Nat,
  });
  const Result_2 = IDL.Variant({ ok: SaleGoalDTO, err: IDL.Text });
  const SaleCountDownDTO = IDL.Record({
    status: IDL.Text,
    timeRemaining: IDL.Nat64,
    stringTime: IDL.Text,
  });
  const Result_1 = IDL.Variant({ ok: SaleCountDownDTO, err: IDL.Text });
  const SaleParticipant = IDL.Record({
    time: IDL.Nat64,
    user: IDL.Principal,
    amount: IDL.Nat,
    icfc_staked: IDL.Float64,
  });
  const Result = IDL.Variant({ ok: IDL.Null, err: IDL.Text });
  const Self = IDL.Service({
    getAppStatus: IDL.Func([], [Result_3], ["query"]),
    get_goal: IDL.Func([], [Result_2], ["query"]),
    get_sale_countdown: IDL.Func([], [Result_1], []),
    get_sale_participants: IDL.Func([], [IDL.Vec(SaleParticipant)], []),
    get_user_ckBTC_balance: IDL.Func([], [IDL.Nat], []),
    get_user_sale_contribution: IDL.Func([], [IDL.Vec(SaleParticipant)], []),
    participate: IDL.Func([IDL.Nat], [Result], []),
  });
  return Self;
};
export const init = ({ IDL }) => {
  return [];
};
