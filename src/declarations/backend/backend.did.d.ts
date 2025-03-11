import type { Principal } from "@dfinity/principal";
import type { ActorMethod } from "@dfinity/agent";
import type { IDL } from "@dfinity/candid";

export interface AppStatusDTO {
  version: string;
  onHold: boolean;
}
export type Error =
  | { DecodeError: null }
  | { NotAllowed: null }
  | { NotFound: null }
  | { NotAuthorized: null }
  | { InvalidData: null }
  | { AlreadyExists: null };
export interface MembershipClaim {
  expiresOn: [] | [bigint];
  claimedOn: bigint;
  membershipType: MembershipType;
}
export type MembershipType =
  | { Lifetime: null }
  | { Monthly: null }
  | { Annual: null };
export type PrincipalId = string;
export interface Profile {
  username: string;
  displayName: string;
  createdOn: bigint;
  profilePictureExtension: string;
  membershipClaims: Array<MembershipClaim>;
  appPrincipalIds: Array<[string, PrincipalId]>;
  profilePicture: Uint8Array | number[];
  membershipType: MembershipType;
  termsAgreed: boolean;
  principalId: PrincipalId;
}
export type Result = { ok: Profile } | { err: Error };
export type Result_1 = { ok: AppStatusDTO } | { err: Error };
export interface _SERVICE {
  getAppStatus: ActorMethod<[], Result_1>;
  getProfile: ActorMethod<[], Result>;
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
