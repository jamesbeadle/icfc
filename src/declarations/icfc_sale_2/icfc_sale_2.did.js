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
  const Result = IDL.Variant({ ok: AppStatusDTO, err: Error });
  const Self = IDL.Service({
    getAppStatus: IDL.Func([], [Result], ["query"]),
  });
  return Self;
};
export const init = ({ IDL }) => {
  return [];
};
