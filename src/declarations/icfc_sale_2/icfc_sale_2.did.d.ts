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
export type Result = { ok: null } | { err: string };
export type Result_1 = { ok: SaleCountDownDTO } | { err: string };
export type Result_2 = { ok: SaleGoalDTO } | { err: string };
export type Result_3 = { ok: AppStatusDTO } | { err: Error };
export interface SaleCountDownDTO {
  status: string;
  timeRemaining: bigint;
  stringTime: string;
}
export interface SaleGoalDTO {
  goal: bigint;
  currentProgress: bigint;
}
export interface SaleParticipant {
  time: bigint;
  user: Principal;
  amount: bigint;
  icfc_staked: number;
}
export interface Self {
  getAppStatus: ActorMethod<[], Result_3>;
  get_goal: ActorMethod<[], Result_2>;
  get_sale_countdown: ActorMethod<[], Result_1>;
  get_sale_participants: ActorMethod<[], Array<SaleParticipant>>;
  get_user_ckBTC_balance: ActorMethod<[], bigint>;
  get_user_sale_contribution: ActorMethod<[], Array<SaleParticipant>>;
  participate: ActorMethod<[bigint], Result>;
}
export interface _SERVICE extends Self {}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
