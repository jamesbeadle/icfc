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
  profilePictureExtension: [] | [string];
  appPrincipalIds: Array<[SubApp, PrincipalId]>;
  profilePicture: [] | [Uint8Array | number[]];
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
  | { OutOfRange: null }
  | { PaymentError: null }
  | { CanisterFull: null }
  | { InEligible: null };
export interface Followees {
  followees: Array<NeuronId>;
}
export interface GetICFCMembership {
  principalId: PrincipalId;
}
export interface ICFCMembershipDTO {
  membershipClaims: Array<MembershipClaim>;
  membershipType: MembershipType;
  membershipExpiryTime: bigint;
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
  favouriteMensLeagueId: [] | [LeagueId];
  username: string;
  favouriteWomensClubId: [] | [ClubId];
  displayName: string;
  createdOn: bigint;
  podcastIds: Array<PrincipalId>;
  favouriteMensClubId: [] | [ClubId];
  profilePictureExtension: string;
  membershipClaims: Array<MembershipClaim>;
  appPrincipalIds: Array<[SubApp, PrincipalId]>;
  profilePicture: [] | [Uint8Array | number[]];
  membershipType: MembershipType;
  termsAgreed: boolean;
  membershipExpiryTime: bigint;
  nationalityId: [] | [CountryId];
  favouriteWomensLeagueId: [] | [LeagueId];
  principalId: PrincipalId;
}
export type Result = { ok: null } | { err: Error };
export type Result_1 = { ok: UserNeuronsDTO } | { err: Error };
export type Result_2 = { ok: ProfileDTO } | { err: Error };
export type Result_3 = { ok: ICFCMembershipDTO } | { err: Error };
export type Result_4 = { ok: Array<CountryDTO> } | { err: Error };
export type Result_5 = { ok: AppStatusDTO } | { err: Error };
export type Result_6 = { ok: MembershipClaim } | { err: Error };
export interface Self {
  addSubApp: ActorMethod<[AddSubApp], Result>;
  claimMembership: ActorMethod<[], Result_6>;
  createProfile: ActorMethod<[CreateProfile], Result>;
  getAppStatus: ActorMethod<[], Result_5>;
  getCountries: ActorMethod<[], Result_4>;
  getICFCMembership: ActorMethod<[GetICFCMembership], Result_3>;
  getProfile: ActorMethod<[], Result_2>;
  getUserNeurons: ActorMethod<[], Result_1>;
  isUsernameValid: ActorMethod<[IsUsernameValid], boolean>;
  removeSubApp: ActorMethod<[SubApp], Result>;
  updateDisplayName: ActorMethod<[UpdateDisplayName], Result>;
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
export interface UpdateDisplayName {
  displayName: string;
  principalId: PrincipalId;
}
export interface UpdateProfilePicture {
  profilePictureExtension: string;
  profilePicture: [] | [Uint8Array | number[]];
  principalId: PrincipalId;
}
export interface UpdateUserName {
  username: string;
  principalId: PrincipalId;
}
export interface UserNeuronsDTO {
  totalMaxStaked: bigint;
  userMembershipEligibility: MembershipType;
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
