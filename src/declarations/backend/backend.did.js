export const idlFactory = ({ IDL }) => {
  const CreateProfile = IDL.Record({
    username: IDL.Text,
    displayName: IDL.Text,
    profilePictureExtension: IDL.Opt(IDL.Text),
    profilePicture: IDL.Opt(IDL.Vec(IDL.Nat8)),
  });
  const Error = IDL.Variant({
    InvalidProfilePicture: IDL.Null,
    DecodeError: IDL.Null,
    TooLong: IDL.Null,
    NotAllowed: IDL.Null,
    NotEnoughFunds: IDL.Null,
    TooShort: IDL.Null,
    NotFound: IDL.Null,
    NotAuthorized: IDL.Null,
    InvalidData: IDL.Null,
    AlreadyExists: IDL.Null,
    CreateGameError: IDL.Null,
    OutOfRange: IDL.Null,
    PaymentError: IDL.Null,
    CanisterFull: IDL.Null,
  });
  const Result = IDL.Variant({ ok: IDL.Null, err: Error });
  const PrincipalId = IDL.Text;
  const Profile = IDL.Record({
    username: IDL.Text,
    profilePictureExtension: IDL.Text,
    profilePicture: IDL.Opt(IDL.Vec(IDL.Nat8)),
    principalId: PrincipalId,
  });
  const Result_2 = IDL.Variant({ ok: Profile, err: Error });
  const AppStatusDTO = IDL.Record({
    version: IDL.Text,
    onHold: IDL.Bool,
  });
  const Result_1 = IDL.Variant({ ok: AppStatusDTO, err: Error });
  const UpdateDisplayName = IDL.Record({
    displayName: IDL.Text,
    principalId: PrincipalId,
  });
  const UpdateProfilePicture = IDL.Record({
    profilePictureExtension: IDL.Text,
    profilePicture: IDL.Opt(IDL.Vec(IDL.Nat8)),
    principalId: PrincipalId,
  });
  const UpdateUserName = IDL.Record({
    username: IDL.Text,
    principalId: PrincipalId,
  });
  const Self = IDL.Service({
    createProfile: IDL.Func([CreateProfile], [Result], []),
    getProfile: IDL.Func([], [Result_2], []),
    get_app_status: IDL.Func([], [Result_1], ["query"]),
    updateDisplayName: IDL.Func([UpdateDisplayName], [Result], []),
    updateProfilePicture: IDL.Func([UpdateProfilePicture], [Result], []),
    updateUsername: IDL.Func([UpdateUserName], [Result], []),
  });
  return Self;
};
export const init = ({ IDL }) => {
  return [];
};
