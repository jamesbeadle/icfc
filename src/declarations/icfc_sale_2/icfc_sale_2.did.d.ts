import type { Principal } from "@dfinity/principal";
import type { ActorMethod } from "@dfinity/agent";
import type { IDL } from "@dfinity/candid";

export interface AppStatus {
  version: string;
  onHold: boolean;
}
export interface Canister {
  app: WaterwayLabsApp;
  canisterName: string;
  canisterType: CanisterType;
  canisterId: CanisterId;
}
export type CanisterId = string;
export type CanisterType = { SNS: null } | { Dynamic: null } | { Static: null };
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
export type Result = { ok: null } | { err: Error };
export type Result_1 = { ok: Array<ICFCDistribution> } | { err: Error };
export type Result_2 = { ok: UserParticipation } | { err: Error };
export type Result_3 = { ok: SaleProgress } | { err: Error };
export type Result_4 = { ok: Canister } | { err: Error };
export type Result_5 = { ok: AppStatus } | { err: Error };
export interface SaleProgress {
  remainingPacks: bigint;
  packCostinICP: bigint;
  totalPacks: bigint;
}
export interface Self {
  claimICFCPacks: ActorMethod<[], Result>;
  getAppStatus: ActorMethod<[], Result_5>;
  getCanisterInfo: ActorMethod<[], Result_4>;
  getProgress: ActorMethod<[], Result_3>;
  getUserParticipation: ActorMethod<[], Result_2>;
  getUsersICFCDistributions: ActorMethod<[], Result_1>;
  transferCycles: ActorMethod<[TopupCanister], Result>;
}
export type Time = bigint;
export interface TopupCanister {
  app: WaterwayLabsApp;
  cycles: bigint;
  canisterId: CanisterId;
}
export interface UserParticipation {
  participations: Array<PurchaseRecord>;
}
export type WaterwayLabsApp =
  | { OpenFPL: null }
  | { OpenWSL: null }
  | { ICPCasino: null }
  | { FootballGod: null }
  | { ICF1: null }
  | { ICFC: null }
  | { ICGC: null }
  | { ICPFA: null }
  | { TransferKings: null }
  | { JeffBets: null }
  | { OpenBook: null }
  | { OpenCare: null }
  | { OpenChef: null }
  | { WaterwayLabs: null };
export interface _SERVICE extends Self {}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
