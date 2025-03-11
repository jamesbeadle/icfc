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
  const Result_1 = IDL.Variant({ ok: AppStatusDTO, err: Error });
  const MembershipType = IDL.Variant({
    Lifetime: IDL.Null,
    Monthly: IDL.Null,
    Annual: IDL.Null,
  });
  const MembershipClaim = IDL.Record({
    expiresOn: IDL.Opt(IDL.Int),
    claimedOn: IDL.Int,
    membershipType: MembershipType,
  });
  const PrincipalId = IDL.Text;
  const Profile = IDL.Record({
    username: IDL.Text,
    displayName: IDL.Text,
    createdOn: IDL.Int,
    profilePictureExtension: IDL.Text,
    membershipClaims: IDL.Vec(MembershipClaim),
    appPrincipalIds: IDL.Vec(IDL.Tuple(IDL.Text, PrincipalId)),
    profilePicture: IDL.Vec(IDL.Nat8),
    membershipType: MembershipType,
    termsAgreed: IDL.Bool,
    principalId: PrincipalId,
  });
  const Result = IDL.Variant({ ok: Profile, err: Error });
  return IDL.Service({
    getAppStatus: IDL.Func([], [Result_1], ["query"]),
    getProfile: IDL.Func([], [Result], ["query"]),
  });
};
export const init = ({ IDL }) => {
  return [];
};
