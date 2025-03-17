import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface Account {
  'owner' : [] | [Principal],
  'subaccount' : [] | [Subaccount],
}
export interface AppStatusDTO { 'version' : string, 'onHold' : boolean }
export interface CreateProfile {
  'username' : string,
  'displayName' : string,
  'profilePictureExtension' : [] | [string],
  'profilePicture' : [] | [Uint8Array | number[]],
}
export interface DisburseMaturityInProgress {
  'timestamp_of_disbursement_seconds' : bigint,
  'amount_e8s' : bigint,
  'account_to_disburse_to' : [] | [Account],
  'finalize_disbursement_timestamp_seconds' : [] | [bigint],
}
export type DissolveState = { 'DissolveDelaySeconds' : bigint } |
  { 'WhenDissolvedTimestampSeconds' : bigint };
export type Error = { 'InvalidProfilePicture' : null } |
  { 'DecodeError' : null } |
  { 'TooLong' : null } |
  { 'NotAllowed' : null } |
  { 'NotEnoughFunds' : null } |
  { 'TooShort' : null } |
  { 'NotFound' : null } |
  { 'AlreadyClaimed' : null } |
  { 'NotAuthorized' : null } |
  { 'InvalidData' : null } |
  { 'AlreadyExists' : null } |
  { 'CreateGameError' : null } |
  { 'UpdateFailed' : null } |
  { 'OutOfRange' : null } |
  { 'PaymentError' : null } |
  { 'CanisterFull' : null } |
  { 'InEligible' : null };
export interface Followees { 'followees' : Array<NeuronId> }
export interface MembershipClaim {
  'expiresOn' : [] | [bigint],
  'claimedOn' : bigint,
  'membershipType' : MembershipType,
}
export type MembershipType = { 'NotClaimed' : null } |
  { 'Seasonal' : null } |
  { 'Lifetime' : null } |
  { 'Monthly' : null } |
  { 'Expired' : null };
export interface Neuron {
  'id' : [] | [NeuronId],
  'staked_maturity_e8s_equivalent' : [] | [bigint],
  'permissions' : Array<NeuronPermission>,
  'maturity_e8s_equivalent' : bigint,
  'cached_neuron_stake_e8s' : bigint,
  'created_timestamp_seconds' : bigint,
  'source_nns_neuron_id' : [] | [bigint],
  'auto_stake_maturity' : [] | [boolean],
  'aging_since_timestamp_seconds' : bigint,
  'dissolve_state' : [] | [DissolveState],
  'voting_power_percentage_multiplier' : bigint,
  'vesting_period_seconds' : [] | [bigint],
  'disburse_maturity_in_progress' : Array<DisburseMaturityInProgress>,
  'followees' : Array<[bigint, Followees]>,
  'neuron_fees_e8s' : bigint,
}
export interface NeuronId { 'id' : Uint8Array | number[] }
export interface NeuronPermission {
  'principal' : [] | [Principal],
  'permission_type' : Int32Array | number[],
}
export type PrincipalId = string;
export interface Profile {
  'username' : string,
  'displayName' : string,
  'createdOn' : bigint,
  'podcastIds' : Array<PrincipalId>,
  'profilePictureExtension' : string,
  'membershipClaims' : Array<MembershipClaim>,
  'appPrincipalIds' : Array<[SubApp, PrincipalId]>,
  'profilePicture' : [] | [Uint8Array | number[]],
  'membershipType' : MembershipType,
  'termsAgreed' : boolean,
  'membershipExpiryTime' : bigint,
  'principalId' : PrincipalId,
}
export type Result = { 'ok' : null } |
  { 'err' : Error };
export type Result_1 = { 'ok' : AppStatusDTO } |
  { 'err' : Error };
export type Result_2 = { 'ok' : Array<Neuron> } |
  { 'err' : Error };
export type Result_3 = { 'ok' : Profile } |
  { 'err' : Error };
export type Result_4 = { 'ok' : MembershipClaim } |
  { 'err' : Error };
export interface Self {
  'claimMembership' : ActorMethod<[], Result_4>,
  'createProfile' : ActorMethod<[CreateProfile], Result>,
  'getProfile' : ActorMethod<[], Result_3>,
  'getUserNeurons' : ActorMethod<[], Result_2>,
  'get_app_status' : ActorMethod<[], Result_1>,
  'updateDisplayName' : ActorMethod<[UpdateDisplayName], Result>,
  'updateProfilePicture' : ActorMethod<[UpdateProfilePicture], Result>,
  'updateUsername' : ActorMethod<[UpdateUserName], Result>,
}
export type SubApp = { 'OpenFPL' : null } |
  { 'OpenWSL' : null } |
  { 'FootballGod' : null } |
  { 'TransferKings' : null } |
  { 'JeffBets' : null };
export interface Subaccount { 'subaccount' : Uint8Array | number[] }
export interface UpdateDisplayName {
  'displayName' : string,
  'principalId' : PrincipalId,
}
export interface UpdateProfilePicture {
  'profilePictureExtension' : string,
  'profilePicture' : [] | [Uint8Array | number[]],
  'principalId' : PrincipalId,
}
export interface UpdateUserName {
  'username' : string,
  'principalId' : PrincipalId,
}
export interface _SERVICE extends Self {}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
