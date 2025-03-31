import {
  type CreatedStore,
  initCreatedStore,
} from "$lib/stores/user-created-store";

export interface UncreatedStore<T> extends Omit<CreatedStore<T>, "set"> {
  set: (data: T) => void;
}

// Just a shorthand. That way we can find easily which store uses the pattern but, not yet query+update.
export const initUncreatedStore = <T>(): UncreatedStore<T> => {
  const { set, ...rest } = initCreatedStore<T>();

  return {
    ...rest,

    set(data) {
      set({
        data,
        certified: false,
      });
    },
  };
};
