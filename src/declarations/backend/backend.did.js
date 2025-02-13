export const idlFactory = ({ IDL }) => {
  const AppStatusDTO = IDL.Record({
    version: IDL.Text,
    onHold: IDL.Bool,
  });
  const Error = IDL.Variant({
    DecodeError: IDL.Null,
    NotAllowed: IDL.Null,
    NotFound: IDL.Null,
    NotAuthorized: IDL.Null,
    InvalidData: IDL.Null,
    AlreadyExists: IDL.Null,
  });
  const Result = IDL.Variant({ ok: AppStatusDTO, err: Error });
  return IDL.Service({ getAppStatus: IDL.Func([], [Result], ["query"]) });
};
export const init = ({ IDL }) => {
  return [];
};
