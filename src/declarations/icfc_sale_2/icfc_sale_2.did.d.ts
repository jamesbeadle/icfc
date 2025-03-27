import type { Principal } from "@dfinity/principal";
import type { ActorMethod } from "@dfinity/agent";
import type { IDL } from "@dfinity/candid";

export interface AppStatusDTO {
  version: string;
  onHold: boolean;
}
export interface CalimICFCPackets {
  packets: bigint;
}
export interface ClaimedRecord {
  packetsClaimed: bigint;
  claimedOn: bigint;
  membershipType: MembershipType;
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
  | { NoPacketsRemaining: null }
  | { CreateGameError: null }
  | { UpdateFailed: null }
  | { NotEligible: null }
  | { OutOfRange: null }
  | { PaymentError: null }
  | { InsufficientPacketsRemaining: null };
export type MembershipType =
  | { Founding: null }
  | { NotClaimed: null }
  | { Seasonal: null }
  | { Lifetime: null }
  | { Monthly: null }
  | { NotEligible: null }
  | { Expired: null };
export type Result = { ok: SaleProgressDTO } | { err: Error };
export type Result_1 = { ok: UserParticipationDTO } | { err: Error };
export type Result_2 = { ok: AppStatusDTO } | { err: Error };
export type Result_3 = { ok: null } | { err: Error };
export interface SaleProgressDTO {
  remainingPackets: bigint;
  totalPackets: bigint;
}
export interface Self {
  claimICFCPackets: ActorMethod<[CalimICFCPackets], Result_3>;
  getAppStatus: ActorMethod<[], Result_2>;
  getUserParticipation: ActorMethod<[], Result_1>;
  get_progress: ActorMethod<[], Result>;
}
export interface UserParticipationDTO {
  participations: Array<ClaimedRecord>;
}
export interface _SERVICE extends Self {}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
