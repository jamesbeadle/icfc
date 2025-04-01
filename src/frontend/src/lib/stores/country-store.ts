import { writable } from "svelte/store";
import { CountryService } from "../services/country-service";
import type { Country } from "../../../../declarations/backend/backend.did";

function createCountryStore() {
  const { subscribe, set } = writable<Country[]>([]);

  async function getCountries() {
    return new CountryService().getCountries();
  }

  return {
    getCountries,
    subscribe,
    setCountries: (countries: Country[]) => set(countries),
  };
}

export const countryStore = createCountryStore();
