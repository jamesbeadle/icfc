import type { CreatedData } from "$lib/types/store";
import type { Option } from "$lib/types/utils";
import { writable, type Readable } from "svelte/store";
import type { Principal } from "@dfinity/principal";

type RestrictedSaleStoreData = Option<CreatedData<Principal | string>>;

export interface RestrictedSaleStore extends Readable<RestrictedSaleStoreData> {
  set: (data: CreatedData<Principal | string>) => void;
  reset: () => void;
}

export const initRestrictedSaleStore = (): RestrictedSaleStore => {
  const { subscribe, set } = writable<RestrictedSaleStoreData>(undefined);

  return {
    subscribe,

    set(data) {
      set(data);
    },

    reset: () => {
      set(null);
    },
  };
};

export const restrictedSaleStore = initRestrictedSaleStore();
