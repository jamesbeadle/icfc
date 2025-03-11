export const idlFactory = ({ IDL }) => {
  const AppStatusDTO = IDL.Record({
    'version' : IDL.Text,
    'onHold' : IDL.Bool,
  });
  const Error = IDL.Variant({
    'DecodeError' : IDL.Null,
    'NotAllowed' : IDL.Null,
    'NotFound' : IDL.Null,
    'NotAuthorized' : IDL.Null,
    'InvalidData' : IDL.Null,
    'AlreadyExists' : IDL.Null,
  });
  const Result_4 = IDL.Variant({ 'ok' : AppStatusDTO, 'err' : Error });
  const SaleGoalDTO = IDL.Record({
    'minGoal' : IDL.Nat,
    'currentProgress' : IDL.Nat,
    'maxGoal' : IDL.Nat,
  });
  const Result_3 = IDL.Variant({ 'ok' : SaleGoalDTO, 'err' : IDL.Text });
  const PrincipalId = IDL.Text;
  const MembershipType = IDL.Variant({
    'Lifetime' : IDL.Null,
    'Monthly' : IDL.Null,
    'Annual' : IDL.Null,
  });
  const MembershipClaim = IDL.Record({
    'expiresOn' : IDL.Opt(IDL.Int),
    'claimedOn' : IDL.Int,
    'membershipType' : MembershipType,
  });
  const Profile = IDL.Record({
    'username' : IDL.Text,
    'displayName' : IDL.Text,
    'createdOn' : IDL.Int,
    'podcastIds' : IDL.Vec(PrincipalId),
    'profilePictureExtension' : IDL.Text,
    'membershipClaims' : IDL.Vec(MembershipClaim),
    'appPrincipalIds' : IDL.Vec(IDL.Tuple(IDL.Text, PrincipalId)),
    'profilePicture' : IDL.Vec(IDL.Nat8),
    'membershipType' : MembershipType,
    'termsAgreed' : IDL.Bool,
    'principalId' : PrincipalId,
  });
  const Result_2 = IDL.Variant({ 'ok' : Profile, 'err' : Error });
  const SaleCountDownDTO = IDL.Record({
    'status' : IDL.Text,
    'timeRemaining' : IDL.Nat64,
    'stringTime' : IDL.Text,
  });
  const Result_1 = IDL.Variant({ 'ok' : SaleCountDownDTO, 'err' : IDL.Text });
  const SaleParticipant = IDL.Record({
    'time' : IDL.Nat64,
    'user' : IDL.Principal,
    'amount' : IDL.Nat,
    'icfc_staked' : IDL.Nat,
  });
  const Result = IDL.Variant({ 'ok' : IDL.Null, 'err' : IDL.Text });
  const Self = IDL.Service({
    'get_app_status' : IDL.Func([], [Result_4], ['query']),
    'get_goal' : IDL.Func([], [Result_3], []),
    'get_goal_progress' : IDL.Func([], [IDL.Nat], []),
    'get_principal' : IDL.Func([], [IDL.Principal], []),
    'get_profile' : IDL.Func([], [Result_2], ['query']),
    'get_sale_countdown' : IDL.Func([], [Result_1], []),
    'get_sale_participants' : IDL.Func([], [IDL.Vec(SaleParticipant)], []),
    'get_user_balance' : IDL.Func([], [IDL.Nat], []),
    'get_user_contribution' : IDL.Func([], [IDL.Vec(SaleParticipant)], []),
    'participate' : IDL.Func([IDL.Nat], [Result], []),
  });
  return Self;
};
export const init = ({ IDL }) => { return []; };
