export const idlFactory = ({ IDL }) => {
  const SubApp = IDL.Variant({
    OpenFPL: IDL.Null,
    OpenWSL: IDL.Null,
    FootballGod: IDL.Null,
    TransferKings: IDL.Null,
    JeffBets: IDL.Null,
  });
  const PrincipalId = IDL.Text;
  const AddSubApp = IDL.Record({
    subApp: SubApp,
    subAppUserPrincipalId: PrincipalId,
  });
  const Error = IDL.Variant({
    InvalidProfilePicture: IDL.Null,
    DecodeError: IDL.Null,
    TooLong: IDL.Null,
    NotAllowed: IDL.Null,
    NotEnoughFunds: IDL.Null,
    TooShort: IDL.Null,
    NotFound: IDL.Null,
    AlreadyClaimed: IDL.Null,
    NotAuthorized: IDL.Null,
    InvalidData: IDL.Null,
    AlreadyExists: IDL.Null,
    CreateGameError: IDL.Null,
    UpdateFailed: IDL.Null,
    NeuronAlreadyUsed: IDL.Null,
    OutOfRange: IDL.Null,
    AlreadyLinked: IDL.Null,
    FailedInterCanisterCall: IDL.Null,
    PaymentError: IDL.Null,
    CanisterFull: IDL.Null,
    InEligible: IDL.Null,
  });
  const Result = IDL.Variant({ ok: IDL.Null, err: Error });
  const MembershipType = IDL.Variant({
    Founding: IDL.Null,
    NotClaimed: IDL.Null,
    Seasonal: IDL.Null,
    Lifetime: IDL.Null,
    Monthly: IDL.Null,
    NotEligible: IDL.Null,
    Expired: IDL.Null,
  });
  const MembershipClaim = IDL.Record({
    expiresOn: IDL.Opt(IDL.Int),
    claimedOn: IDL.Int,
    membershipType: MembershipType,
  });
  const Result_7 = IDL.Variant({ ok: MembershipClaim, err: Error });
  const ClubId = IDL.Nat16;
  const LeagueId = IDL.Nat16;
  const CountryId = IDL.Nat16;
  const CreateProfile = IDL.Record({
    username: IDL.Text,
    displayName: IDL.Text,
    favouriteClubId: IDL.Opt(ClubId),
    appPrincipalIds: IDL.Vec(IDL.Tuple(SubApp, PrincipalId)),
    profilePicture: IDL.Opt(IDL.Vec(IDL.Nat8)),
    favouriteLeagueId: IDL.Opt(LeagueId),
    nationalityId: IDL.Opt(CountryId),
  });
  const AppStatus = IDL.Record({ version: IDL.Text, onHold: IDL.Bool });
  const Result_6 = IDL.Variant({ ok: AppStatus, err: Error });
  const CountryDTO = IDL.Record({
    id: CountryId,
    code: IDL.Text,
    name: IDL.Text,
  });
  const Result_5 = IDL.Variant({ ok: IDL.Vec(CountryDTO), err: Error });
  const GetICFCProfile = IDL.Record({ principalId: PrincipalId });
  const ProfileDTO = IDL.Record({
    username: IDL.Text,
    displayName: IDL.Text,
    createdOn: IDL.Int,
    podcastIds: IDL.Vec(PrincipalId),
    favouriteClubId: IDL.Opt(ClubId),
    membershipClaims: IDL.Vec(MembershipClaim),
    appPrincipalIds: IDL.Vec(IDL.Tuple(SubApp, PrincipalId)),
    profilePicture: IDL.Opt(IDL.Vec(IDL.Nat8)),
    membershipType: MembershipType,
    termsAgreed: IDL.Bool,
    membershipExpiryTime: IDL.Int,
    favouriteLeagueId: IDL.Opt(LeagueId),
    nationalityId: IDL.Opt(CountryId),
    principalId: PrincipalId,
  });
  const Result_3 = IDL.Variant({ ok: ProfileDTO, err: Error });
  const ICFCProfileSummary = IDL.Record({
    username: IDL.Text,
    displayName: IDL.Text,
    membershipClaim: MembershipClaim,
    createdOn: IDL.Int,
    favouriteClubId: IDL.Opt(ClubId),
    profilePicture: IDL.Opt(IDL.Vec(IDL.Nat8)),
    membershipType: MembershipType,
    termsAgreed: IDL.Bool,
    membershipExpiryTime: IDL.Int,
    favouriteLeagueId: IDL.Opt(LeagueId),
    nationalityId: IDL.Opt(CountryId),
    principalId: PrincipalId,
  });
  const Result_4 = IDL.Variant({ ok: ICFCProfileSummary, err: Error });
  const TokenBalances = IDL.Record({
    icgcBalance: IDL.Nat,
    icfcBalance: IDL.Nat,
    icpBalance: IDL.Nat,
    ckBTCBalance: IDL.Nat,
  });
  const Result_2 = IDL.Variant({ ok: TokenBalances, err: Error });
  const EligibleMembership = IDL.Record({
    eligibleNeuronIds: IDL.Vec(IDL.Vec(IDL.Nat8)),
    membershipType: MembershipType,
  });
  const NeuronId = IDL.Record({ id: IDL.Vec(IDL.Nat8) });
  const NeuronPermission = IDL.Record({
    principal: IDL.Opt(IDL.Principal),
    permission_type: IDL.Vec(IDL.Int32),
  });
  const DissolveState = IDL.Variant({
    DissolveDelaySeconds: IDL.Nat64,
    WhenDissolvedTimestampSeconds: IDL.Nat64,
  });
  const Subaccount = IDL.Record({ subaccount: IDL.Vec(IDL.Nat8) });
  const Account = IDL.Record({
    owner: IDL.Opt(IDL.Principal),
    subaccount: IDL.Opt(Subaccount),
  });
  const DisburseMaturityInProgress = IDL.Record({
    timestamp_of_disbursement_seconds: IDL.Nat64,
    amount_e8s: IDL.Nat64,
    account_to_disburse_to: IDL.Opt(Account),
    finalize_disbursement_timestamp_seconds: IDL.Opt(IDL.Nat64),
  });
  const Followees = IDL.Record({ followees: IDL.Vec(NeuronId) });
  const Neuron = IDL.Record({
    id: IDL.Opt(NeuronId),
    staked_maturity_e8s_equivalent: IDL.Opt(IDL.Nat64),
    permissions: IDL.Vec(NeuronPermission),
    maturity_e8s_equivalent: IDL.Nat64,
    cached_neuron_stake_e8s: IDL.Nat64,
    created_timestamp_seconds: IDL.Nat64,
    source_nns_neuron_id: IDL.Opt(IDL.Nat64),
    auto_stake_maturity: IDL.Opt(IDL.Bool),
    aging_since_timestamp_seconds: IDL.Nat64,
    dissolve_state: IDL.Opt(DissolveState),
    voting_power_percentage_multiplier: IDL.Nat64,
    vesting_period_seconds: IDL.Opt(IDL.Nat64),
    disburse_maturity_in_progress: IDL.Vec(DisburseMaturityInProgress),
    followees: IDL.Vec(IDL.Tuple(IDL.Nat64, Followees)),
    neuron_fees_e8s: IDL.Nat64,
  });
  const UserNeuronsDTO = IDL.Record({
    totalMaxStaked: IDL.Nat64,
    userMembershipEligibility: EligibleMembership,
    userNeurons: IDL.Vec(Neuron),
  });
  const Result_1 = IDL.Variant({ ok: UserNeuronsDTO, err: Error });
  const IsUsernameValid = IDL.Record({ username: IDL.Text });
  const UpdateDisplayName = IDL.Record({
    displayName: IDL.Text,
    principalId: PrincipalId,
  });
  const UpdateFavouriteClub = IDL.Record({
    favouriteClubId: ClubId,
    favouriteLeagueId: LeagueId,
    principalId: PrincipalId,
  });
  const UpdateNationality = IDL.Record({
    nationalityId: CountryId,
    principalId: PrincipalId,
  });
  const UpdateProfilePicture = IDL.Record({
    profilePicture: IDL.Opt(IDL.Vec(IDL.Nat8)),
    principalId: PrincipalId,
  });
  const UpdateUserName = IDL.Record({
    username: IDL.Text,
    principalId: PrincipalId,
  });
  const VerifySubApp = IDL.Record({
    icfcPrincipalId: PrincipalId,
    subApp: SubApp,
    subAppUserPrincipalId: PrincipalId,
  });
  const Self = IDL.Service({
    addSubApp: IDL.Func([AddSubApp], [Result], []),
    claimMembership: IDL.Func([], [Result_7], []),
    createProfile: IDL.Func([CreateProfile], [Result], []),
    getAppStatus: IDL.Func([], [Result_6], ["query"]),
    getCountries: IDL.Func([], [Result_5], ["query"]),
    getICFCProfile: IDL.Func([GetICFCProfile], [Result_3], []),
    getICFCProfileSummary: IDL.Func([GetICFCProfile], [Result_4], []),
    getProfile: IDL.Func([], [Result_3], []),
    getTokenBalances: IDL.Func([], [Result_2], []),
    getUserNeurons: IDL.Func([], [Result_1], []),
    isUsernameValid: IDL.Func([IsUsernameValid], [IDL.Bool], ["query"]),
    removeNeuronsforExpiredMembership: IDL.Func([PrincipalId], [], []),
    removeSubApp: IDL.Func([SubApp], [Result], []),
    updateDisplayName: IDL.Func([UpdateDisplayName], [Result], []),
    updateFavouriteClub: IDL.Func([UpdateFavouriteClub], [Result], []),
    updateNationality: IDL.Func([UpdateNationality], [Result], []),
    updateProfilePicture: IDL.Func([UpdateProfilePicture], [Result], []),
    updateUsername: IDL.Func([UpdateUserName], [Result], []),
    verifySubApp: IDL.Func([VerifySubApp], [Result], []),
  });
  return Self;
};
export const init = ({ IDL }) => {
  return [];
};
