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
export type Result = { ok: Array<ICFCDistribution> } | { err: Error };
export type Result_1 = { ok: UserParticipationDTO } | { err: Error };
export type Result_2 = { ok: SaleProgressDTO } | { err: Error };
export type Result_3 = { ok: AppStatusDTO } | { err: Error };
export type Result_4 = { ok: null } | { err: Error };
export interface SaleProgressDTO {
  remainingPackets: bigint;
  totalPackets: bigint;
}
export interface Self {
  claimICFCPackets: ActorMethod<[CalimICFCPackets], Result_4>;
  getAppStatus: ActorMethod<[], Result_3>;
  getProgress: ActorMethod<[], Result_2>;
  getUserParticipation: ActorMethod<[], Result_1>;
  getUsersICFCDistributions: ActorMethod<[], Result>;
}
export type Time = bigint;
export interface UserParticipationDTO {
  participations: Array<ClaimedRecord>;
}
export interface _SERVICE extends Self {}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
