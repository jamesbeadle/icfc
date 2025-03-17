import type { Principal } from "@dfinity/principal";
import type { ActorMethod } from "@dfinity/agent";
import type { IDL } from "@dfinity/candid";

export interface AppStatusDTO {
  version: string;
  onHold: boolean;
}
export interface CreateProfile {
  username: string;
  displayName: string;
  profilePictureExtension: [] | [string];
  profilePicture: [] | [Uint8Array | number[]];
}
export type Error =
  | { InvalidProfilePicture: null }
  | { DecodeError: null }
  | { TooLong: null }
  | { NotAllowed: null }
  | { NotEnoughFunds: null }
  | { TooShort: null }
  | { NotFound: null }
  | { NotAuthorized: null }
  | { InvalidData: null }
  | { AlreadyExists: null }
  | { CreateGameError: null }
  | { OutOfRange: null }
  | { PaymentError: null }
  | { CanisterFull: null };
export type PrincipalId = string;
export interface Profile {
  username: string;
  profilePictureExtension: string;
  profilePicture: [] | [Uint8Array | number[]];
  principalId: PrincipalId;
}
export type Result = { ok: null } | { err: Error };
export type Result_1 = { ok: AppStatusDTO } | { err: Error };
export type Result_2 = { ok: Profile } | { err: Error };
export interface Self {
  createProfile: ActorMethod<[CreateProfile], Result>;
  getProfile: ActorMethod<[], Result_2>;
  get_app_status: ActorMethod<[], Result_1>;
  updateDisplayName: ActorMethod<[UpdateDisplayName], Result>;
  updateProfilePicture: ActorMethod<[UpdateProfilePicture], Result>;
  updateUsername: ActorMethod<[UpdateUserName], Result>;
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
export interface _SERVICE extends Self {}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
