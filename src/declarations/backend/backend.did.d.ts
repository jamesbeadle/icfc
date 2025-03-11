import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface AppStatusDTO { 'version' : string, 'onHold' : boolean }
export type Error = { 'DecodeError' : null } |
  { 'NotAllowed' : null } |
  { 'NotFound' : null } |
  { 'NotAuthorized' : null } |
  { 'InvalidData' : null } |
  { 'AlreadyExists' : null };
export interface MembershipClaim {
  'expiresOn' : [] | [bigint],
  'claimedOn' : bigint,
  'membershipType' : MembershipType,
}
export type MembershipType = { 'Lifetime' : null } |
  { 'Monthly' : null } |
  { 'Annual' : null };
export type PrincipalId = string;
export interface Profile {
  'username' : string,
  'displayName' : string,
  'createdOn' : bigint,
  'podcastIds' : Array<PrincipalId>,
  'profilePictureExtension' : string,
  'membershipClaims' : Array<MembershipClaim>,
  'appPrincipalIds' : Array<[string, PrincipalId]>,
  'profilePicture' : Uint8Array | number[],
  'membershipType' : MembershipType,
  'termsAgreed' : boolean,
  'principalId' : PrincipalId,
}
export type Result = { 'ok' : null } |
  { 'err' : string };
export type Result_1 = { 'ok' : SaleCountDownDTO } |
  { 'err' : string };
export type Result_2 = { 'ok' : Profile } |
  { 'err' : Error };
export type Result_3 = { 'ok' : SaleGoalDTO } |
  { 'err' : string };
export type Result_4 = { 'ok' : AppStatusDTO } |
  { 'err' : Error };
export interface SaleCountDownDTO {
  'status' : string,
  'timeRemaining' : bigint,
  'stringTime' : string,
}
export interface SaleGoalDTO {
  'minGoal' : bigint,
  'currentProgress' : bigint,
  'maxGoal' : bigint,
}
export interface SaleParticipant {
  'time' : bigint,
  'user' : Principal,
  'amount' : bigint,
  'icfc_staked' : bigint,
}
export interface Self {
  'get_app_status' : ActorMethod<[], Result_4>,
  'get_goal' : ActorMethod<[], Result_3>,
  'get_goal_progress' : ActorMethod<[], bigint>,
  'get_principal' : ActorMethod<[], Principal>,
  'get_profile' : ActorMethod<[], Result_2>,
  'get_sale_countdown' : ActorMethod<[], Result_1>,
  'get_sale_participants' : ActorMethod<[], Array<SaleParticipant>>,
  'get_user_balance' : ActorMethod<[], bigint>,
  'get_user_contribution' : ActorMethod<[], Array<SaleParticipant>>,
  'participate' : ActorMethod<[bigint], Result>,
}
export interface _SERVICE extends Self {}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
