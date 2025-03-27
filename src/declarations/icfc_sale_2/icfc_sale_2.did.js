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
  const Result_1 = IDL.Variant({ ok: AppStatusDTO, err: Error });
  const PrincipalId = IDL.Text;
  const Result = IDL.Variant({ ok: PrincipalId, err: IDL.Text });
  const Self = IDL.Service({
    getAppStatus: IDL.Func([], [Result_1], ["query"]),
    getPrinciapl: IDL.Func([], [Result], []),
  });
  return Self;
};
export const init = ({ IDL }) => {
  return [];
};
