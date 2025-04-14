import type { Principal } from "@dfinity/principal";
import type { ActorMethod } from "@dfinity/agent";
import type { IDL } from "@dfinity/candid";

export interface Account {
  owner: [] | [Principal];
  subaccount: [] | [Subaccount];
}
export interface AddController {
  app: WaterwayLabsApp;
  controller: PrincipalId;
  canisterId: CanisterId;
}
export interface AddSubApp {
  subApp: SubApp;
  subAppUserPrincipalId: PrincipalId;
}
export interface AppStatus {
  version: string;
  onHold: boolean;
}
export interface Canister {
  app: WaterwayLabsApp;
  canisterName: string;
  canisterType: CanisterType;
  canisterId: CanisterId;
}
export type CanisterId = string;
export type CanisterType = { SNS: null } | { Dynamic: null } | { Static: null };
export interface Club {
  id: ClubId;
  secondaryColourHex: string;
  name: string;
  friendlyName: string;
  thirdColourHex: string;
  abbreviatedName: string;
  shirtType: ShirtType;
  primaryColourHex: string;
}
export type ClubId = number;
export interface Clubs {
  clubs: Array<Club>;
  leagueId: LeagueId;
}
export interface Countries {
  countries: Array<Country>;
}
export interface Country {
  id: CountryId;
  code: string;
  name: string;
}
export type CountryId = number;
export interface CreateProfile {
  username: string;
  displayName: string;
  favouriteClubId: [] | [ClubId];
  profilePicture: [] | [Uint8Array | number[]];
  favouriteLeagueId: [] | [LeagueId];
  nationalityId: [] | [CountryId];
}
export interface DisburseMaturityInProgress {
  timestamp_of_disbursement_seconds: bigint;
  amount_e8s: bigint;
  account_to_disburse_to: [] | [Account];
  finalize_disbursement_timestamp_seconds: [] | [bigint];
}
export type DissolveState =
  | { DissolveDelaySeconds: bigint }
  | { WhenDissolvedTimestampSeconds: bigint };
export interface EligibleMembership {
  eligibleNeuronIds: Array<Uint8Array | number[]>;
  membershipType: MembershipType;
}
export type Error =
  | { InvalidProfilePicture: null }
  | { DecodeError: null }
  | { TooLong: null }
  | { NotAllowed: null }
  | { DuplicateData: null }
  | { InvalidProperty: null }
  | { NotFound: null }
  | { IncorrectSetup: null }
  | { AlreadyClaimed: null }
  | { NotAuthorized: null }
  | { MaxDataExceeded: null }
  | { InvalidData: null }
  | { SystemOnHold: null }
  | { AlreadyExists: null }
  | { NoPacketsRemaining: null }
  | { UpdateFailed: null }
  | { CanisterCreateError: null }
  | { NeuronAlreadyUsed: null }
  | { FailedInterCanisterCall: null }
  | { InsufficientPacketsRemaining: null }
  | { InsufficientFunds: null }
  | { InEligible: null };
export interface Followees {
  followees: Array<NeuronId>;
}
export type Gender = { Male: null } | { Female: null };
export interface GetClubs {
  leagueId: LeagueId;
}
export type GetCountries = {};
export interface GetICFCProfile {
  principalId: PrincipalId;
}
export type GetLeagues = {};
export interface ICFCProfileSummary {
  username: string;
  displayName: string;
  createdOn: bigint;
  favouriteClubId: [] | [ClubId];
  membershipClaims: Array<MembershipClaim>;
  profilePicture: [] | [Uint8Array | number[]];
  membershipType: MembershipType;
  termsAgreed: boolean;
  membershipExpiryTime: bigint;
  favouriteLeagueId: [] | [LeagueId];
  nationalityId: [] | [CountryId];
  principalId: PrincipalId;
}
export interface IsUsernameValid {
  username: string;
}
export interface League {
  id: LeagueId;
  logo: Uint8Array | number[];
  name: string;
  teamCount: number;
  relatedGender: Gender;
  countryId: CountryId;
  abbreviation: string;
  governingBody: string;
  formed: bigint;
}
export type LeagueId = number;
export interface Leagues {
  leagues: Array<League>;
}
export interface MembershipClaim {
  expiresOn: [] | [bigint];
  purchasedOn: bigint;
  membershipType: MembershipType;
}
export interface MembershipClaim__1 {
  expiresOn: [] | [bigint];
  purchasedOn: bigint;
  membershipType: MembershipType__1;
}
export type MembershipType =
  | { Founding: null }
  | { NotClaimed: null }
  | { Seasonal: null }
  | { Lifetime: null }
  | { Monthly: null }
  | { NotEligible: null }
  | { Expired: null };
export type MembershipType__1 =
  | { Founding: null }
  | { NotClaimed: null }
  | { Seasonal: null }
  | { Lifetime: null }
  | { Monthly: null }
  | { NotEligible: null }
  | { Expired: null };
export interface Neuron {
  id: [] | [NeuronId];
  staked_maturity_e8s_equivalent: [] | [bigint];
  permissions: Array<NeuronPermission>;
  maturity_e8s_equivalent: bigint;
  cached_neuron_stake_e8s: bigint;
  created_timestamp_seconds: bigint;
  source_nns_neuron_id: [] | [bigint];
  auto_stake_maturity: [] | [boolean];
  aging_since_timestamp_seconds: bigint;
  dissolve_state: [] | [DissolveState];
  voting_power_percentage_multiplier: bigint;
  vesting_period_seconds: [] | [bigint];
  disburse_maturity_in_progress: Array<DisburseMaturityInProgress>;
  followees: Array<[bigint, Followees]>;
  neuron_fees_e8s: bigint;
}
export interface NeuronId {
  id: Uint8Array | number[];
}
export interface NeuronPermission {
  principal: [] | [Principal];
  permission_type: Int32Array | number[];
}
export type PrincipalId = string;
export interface ProfileDTO {
  username: string;
  displayName: string;
  createdOn: bigint;
  podcastIds: Array<PrincipalId>;
  favouriteClubId: [] | [ClubId];
  membershipClaims: Array<MembershipClaim>;
  appPrincipalIds: Array<[SubApp__2, PrincipalId]>;
  profilePicture: [] | [Uint8Array | number[]];
  membershipType: MembershipType__1;
  termsAgreed: boolean;
  membershipExpiryTime: bigint;
  favouriteLeagueId: [] | [LeagueId];
  nationalityId: [] | [CountryId];
  principalId: PrincipalId;
}
export interface ProjectCanisters {
  entries: Array<Canister>;
}
export interface RemoveController {
  app: WaterwayLabsApp;
  controller: PrincipalId;
  canisterId: CanisterId;
}
export type Result = { ok: null } | { err: Error };
export type Result_1 = { ok: UserNeuronsDTO } | { err: Error };
export type Result_10 = { ok: AppStatus } | { err: Error };
export type Result_11 = { ok: MembershipClaim__1 } | { err: Error };
export type Result_2 = { ok: TokenBalances } | { err: Error };
export type Result_3 = { ok: ProjectCanisters } | { err: Error };
export type Result_4 = { ok: ProfileDTO } | { err: Error };
export type Result_5 = { ok: Leagues } | { err: Error };
export type Result_6 = { ok: bigint } | { err: Error };
export type Result_7 = { ok: ICFCProfileSummary } | { err: Error };
export type Result_8 = { ok: Countries } | { err: Error };
export type Result_9 = { ok: Clubs } | { err: Error };
export interface Self {
  addController: ActorMethod<[AddController], Result>;
  addSubApp: ActorMethod<[AddSubApp], Result>;
  claimMembership: ActorMethod<[], Result_11>;
  completeICFCPackPurchase: ActorMethod<[PrincipalId, bigint], Result>;
  createProfile: ActorMethod<[CreateProfile], Result>;
  getAppStatus: ActorMethod<[], Result_10>;
  getCanisterIds: ActorMethod<[], Array<CanisterId>>;
  getClubs: ActorMethod<[GetClubs], Result_9>;
  getCountries: ActorMethod<[GetCountries], Result_8>;
  getICFCProfile: ActorMethod<[GetICFCProfile], Result_4>;
  getICFCProfileSummary: ActorMethod<[GetICFCProfile], Result_7>;
  getICPBalance: ActorMethod<[PrincipalId], Result_6>;
  getLeagues: ActorMethod<[GetLeagues], Result_5>;
  getProfile: ActorMethod<[], Result_4>;
  getProfileCanisterIds: ActorMethod<[], Array<CanisterId>>;
  getProfileCanisterIndex: ActorMethod<[], Array<[PrincipalId, CanisterId]>>;
  getProjectCanisters: ActorMethod<[], Result_3>;
  getTokenBalances: ActorMethod<[], Result_2>;
  getUserNeurons: ActorMethod<[], Result_1>;
  isUsernameValid: ActorMethod<[IsUsernameValid], boolean>;
  removeController: ActorMethod<[RemoveController], Result>;
  removeNeuronsforExpiredMembership: ActorMethod<[PrincipalId], undefined>;
  removeSubApp: ActorMethod<[SubApp__1], Result>;
  transferCycles: ActorMethod<[TopupCanister], Result>;
  updateDisplayName: ActorMethod<[UpdateDisplayName], Result>;
  updateFavouriteClub: ActorMethod<[UpdateFavouriteClub], Result>;
  updateNationality: ActorMethod<[UpdateNationality], Result>;
  updateProfilePicture: ActorMethod<[UpdateProfilePicture], Result>;
  updateUsername: ActorMethod<[UpdateUserName], Result>;
  verifySubApp: ActorMethod<[VerifySubApp], Result>;
}
export type ShirtType = { Filled: null } | { Striped: null };
export type SubApp =
  | { OpenFPL: null }
  | { OpenWSL: null }
  | { FootballGod: null }
  | { TransferKings: null }
  | { JeffBets: null };
export type SubApp__1 =
  | { OpenFPL: null }
  | { OpenWSL: null }
  | { FootballGod: null }
  | { TransferKings: null }
  | { JeffBets: null };
export type SubApp__2 =
  | { OpenFPL: null }
  | { OpenWSL: null }
  | { FootballGod: null }
  | { TransferKings: null }
  | { JeffBets: null };
export interface Subaccount {
  subaccount: Uint8Array | number[];
}
export interface TokenBalances {
  icgcBalance: bigint;
  icfcBalance: bigint;
  icpBalance: bigint;
  ckBTCBalance: bigint;
}
export interface TopupCanister {
  app: WaterwayLabsApp;
  cycles: bigint;
  canisterId: CanisterId;
}
export interface UpdateDisplayName {
  displayName: string;
}
export interface UpdateFavouriteClub {
  favouriteClubId: ClubId;
  favouriteLeagueId: LeagueId;
}
export interface UpdateNationality {
  nationalityId: CountryId;
}
export interface UpdateProfilePicture {
  profilePicture: [] | [Uint8Array | number[]];
}
export interface UpdateUserName {
  username: string;
}
export interface UserNeuronsDTO {
  totalMaxStaked: bigint;
  userMembershipEligibility: EligibleMembership;
  userNeurons: Array<Neuron>;
}
export interface VerifySubApp {
  icfcPrincipalId: PrincipalId;
  subApp: SubApp;
  subAppUserPrincipalId: PrincipalId;
}
export type WaterwayLabsApp =
  | { OpenFPL: null }
  | { OpenWSL: null }
  | { ICPCasino: null }
  | { FootballGod: null }
  | { ICF1: null }
  | { ICFC: null }
  | { ICGC: null }
  | { ICPFA: null }
  | { TransferKings: null }
  | { JeffBets: null }
  | { OpenBook: null }
  | { OpenCare: null }
  | { OpenChef: null }
  | { WaterwayLabs: null };
export interface _SERVICE extends Self {}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
