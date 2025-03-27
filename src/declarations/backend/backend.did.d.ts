import type { Principal } from "@dfinity/principal";
import type { ActorMethod } from "@dfinity/agent";
import type { IDL } from "@dfinity/candid";

export interface Account {
  owner: [] | [Principal];
  subaccount: [] | [Subaccount];
}
export interface AddSubApp {
  subApp: SubApp;
  subAppUserPrincipalId: PrincipalId;
}
export interface AppStatusDTO {
  version: string;
  onHold: boolean;
}
export type ClubId = number;
export interface CountryDTO {
  id: CountryId;
  code: string;
  name: string;
}
export type CountryId = number;
export interface CreateProfile {
  username: string;
  displayName: string;
  favouriteClubId: [] | [ClubId];
  appPrincipalIds: Array<[SubApp, PrincipalId]>;
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
  | { NotEnoughFunds: null }
  | { TooShort: null }
  | { NotFound: null }
  | { AlreadyClaimed: null }
  | { NotAuthorized: null }
  | { InvalidData: null }
  | { AlreadyExists: null }
  | { CreateGameError: null }
  | { UpdateFailed: null }
  | { NeuronAlreadyUsed: null }
  | { OutOfRange: null }
  | { AlreadyLinked: null }
  | { FailedInterCanisterCall: null }
  | { PaymentError: null }
  | { CanisterFull: null }
  | { InEligible: null };
export interface Followees {
  followees: Array<NeuronId>;
}
export interface GetICFCProfile {
  principalId: PrincipalId;
}
export interface ICFCProfileSummary {
  username: string;
  displayName: string;
  membershipClaim: MembershipClaim;
  createdOn: bigint;
  favouriteClubId: [] | [ClubId];
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
export type LeagueId = number;
export interface MembershipClaim {
  expiresOn: [] | [bigint];
  claimedOn: bigint;
  membershipType: MembershipType;
}
export type MembershipType =
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
  appPrincipalIds: Array<[SubApp, PrincipalId]>;
  profilePicture: [] | [Uint8Array | number[]];
  membershipType: MembershipType;
  termsAgreed: boolean;
  membershipExpiryTime: bigint;
  favouriteLeagueId: [] | [LeagueId];
  nationalityId: [] | [CountryId];
  principalId: PrincipalId;
}
export type Result = { ok: null } | { err: Error };
export type Result_1 = { ok: UserNeuronsDTO } | { err: Error };
export type Result_2 = { ok: TokenBalances } | { err: Error };
export type Result_3 = { ok: ProfileDTO } | { err: Error };
export type Result_4 = { ok: ICFCProfileSummary } | { err: Error };
export type Result_5 = { ok: Array<CountryDTO> } | { err: Error };
export type Result_6 = { ok: AppStatusDTO } | { err: Error };
export type Result_7 = { ok: MembershipClaim } | { err: Error };
export interface Self {
  addSubApp: ActorMethod<[AddSubApp], Result>;
  claimMembership: ActorMethod<[], Result_7>;
  createProfile: ActorMethod<[CreateProfile], Result>;
  getAppStatus: ActorMethod<[], Result_6>;
  getCountries: ActorMethod<[], Result_5>;
  getICFCProfile: ActorMethod<[GetICFCProfile], Result_3>;
  getICFCProfileSummary: ActorMethod<[GetICFCProfile], Result_4>;
  getProfile: ActorMethod<[], Result_3>;
  getTokenBalances: ActorMethod<[], Result_2>;
  getUserNeurons: ActorMethod<[], Result_1>;
  isUsernameValid: ActorMethod<[IsUsernameValid], boolean>;
  removeNeuronsforExpiredMembership: ActorMethod<[PrincipalId], undefined>;
  removeSubApp: ActorMethod<[SubApp], Result>;
  updateDisplayName: ActorMethod<[UpdateDisplayName], Result>;
  updateFavouriteClub: ActorMethod<[UpdateFavouriteClub], Result>;
  updateNationality: ActorMethod<[UpdateNationality], Result>;
  updateProfilePicture: ActorMethod<[UpdateProfilePicture], Result>;
  updateUsername: ActorMethod<[UpdateUserName], Result>;
  verifySubApp: ActorMethod<[VerifySubApp], Result>;
}
export type SubApp =
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
export interface UpdateDisplayName {
  displayName: string;
  principalId: PrincipalId;
}
export interface UpdateFavouriteClub {
  favouriteClubId: ClubId;
  favouriteLeagueId: LeagueId;
  principalId: PrincipalId;
}
export interface UpdateNationality {
  nationalityId: CountryId;
  principalId: PrincipalId;
}
export interface UpdateProfilePicture {
  profilePicture: [] | [Uint8Array | number[]];
  principalId: PrincipalId;
}
export interface UpdateUserName {
  username: string;
  principalId: PrincipalId;
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
export interface _SERVICE extends Self {}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
