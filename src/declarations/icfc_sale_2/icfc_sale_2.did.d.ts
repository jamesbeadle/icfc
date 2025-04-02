import type { Principal } from "@dfinity/principal";
import type { ActorMethod } from "@dfinity/agent";
import type { IDL } from "@dfinity/candid";

export interface AppStatus {
  version: string;
  onHold: boolean;
}
export interface CalimICFCPackets {
  packets: bigint;
}
export interface ClaimedRecord {
  packetsClaimed: bigint;
  claimId: bigint;
  claimedOn: bigint;
}
export type DistributionStatus = { Completed: null } | { Pending: null };
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
export interface ICFCDistribution {
  time: Time;
  claimId: bigint;
  installment: bigint;
  distributionStatus: DistributionStatus;
  amount: bigint;
  principalId: PrincipalId;
}
export type PrincipalId = string;
export type Result = { ok: null } | { err: Error };
export type Result_1 = { ok: Array<ICFCDistribution> } | { err: Error };
export type Result_2 = { ok: UserParticipation } | { err: Error };
export type Result_3 = { ok: SaleProgress } | { err: Error };
export type Result_4 = { ok: AppStatus } | { err: Error };
export interface SaleProgress {
  remainingPackets: bigint;
  totalPackets: bigint;
}
export interface Self {
  claimICFCPackets: ActorMethod<[CalimICFCPackets], Result>;
  getAppStatus: ActorMethod<[], Result_4>;
  getProgress: ActorMethod<[], Result_3>;
  getUserParticipation: ActorMethod<[], Result_2>;
  getUsersICFCDistributions: ActorMethod<[], Result_1>;
  refreshParticipant: ActorMethod<[], Result>;
}
export type Time = bigint;
export interface UserParticipation {
  participations: Array<ClaimedRecord>;
}
export interface _SERVICE extends Self {}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
