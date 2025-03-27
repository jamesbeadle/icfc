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
  | { NotEnoughFunds: null }
  | { NotFound: null }
  | { AlreadyClaimed: null }
  | { NotAuthorized: null }
  | { InvalidData: null }
  | { AlreadyExists: null }
  | { CreateGameError: null }
  | { UpdateFailed: null }
  | { OutOfRange: null }
  | { PaymentError: null };
export type PrincipalId = string;
export type Result = { ok: PrincipalId } | { err: string };
export type Result_1 = { ok: AppStatusDTO } | { err: Error };
export interface Self {
  getAppStatus: ActorMethod<[], Result_1>;
  getPrinciapl: ActorMethod<[], Result>;
}
export interface _SERVICE extends Self {}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
