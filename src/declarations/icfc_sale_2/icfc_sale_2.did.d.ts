import type { Principal } from "@dfinity/principal";
import type { ActorMethod } from "@dfinity/agent";
import type { IDL } from "@dfinity/candid";

export interface AppStatus {
  version: string;
  onHold: boolean;
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
  installment: bigint;
  distributionStatus: DistributionStatus;
  purchaseId: bigint;
  amount: bigint;
  principalId: PrincipalId;
}
export type PrincipalId = string;
export interface PurchaseRecord {
  purchasedOn: bigint;
  packsPurchased: bigint;
  purchaseId: bigint;
}
export type Result = { ok: Array<ICFCDistribution> } | { err: Error };
export type Result_1 = { ok: UserParticipation } | { err: Error };
export type Result_2 = { ok: SaleProgress } | { err: Error };
export type Result_3 = { ok: AppStatus } | { err: Error };
export type Result_4 = { ok: null } | { err: Error };
export interface SaleProgress {
  remainingPacks: bigint;
  packCostinICP: bigint;
  totalPacks: bigint;
}
export interface Self {
  claimICFCPacks: ActorMethod<[], Result_4>;
  getAppStatus: ActorMethod<[], Result_3>;
  getProgress: ActorMethod<[], Result_2>;
  getUserParticipation: ActorMethod<[], Result_1>;
  getUsersICFCDistributions: ActorMethod<[], Result>;
}
export type Time = bigint;
export interface UserParticipation {
  participations: Array<PurchaseRecord>;
}
export interface _SERVICE extends Self {}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
