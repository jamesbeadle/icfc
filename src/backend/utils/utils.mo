import Nat64 "mo:base/Nat64";
module Utils {
    public func convertNanoToTime(nanoseconds : Nat64) : async (Nat, Nat, Nat, Nat) {
        let secondsPerMinute : Nat64 = 60;
        let secondsPerHour : Nat64 = 60 * secondsPerMinute;
        let secondsPerDay : Nat64 = 24 * secondsPerHour;

        let totalSeconds = nanoseconds / 1_000_000_000;

        let days = Nat64.toNat(totalSeconds / secondsPerDay);
        let hours = Nat64.toNat((totalSeconds % secondsPerDay) / secondsPerHour);
        let minutes = Nat64.toNat((totalSeconds % secondsPerHour) / secondsPerMinute);
        let seconds = Nat64.toNat(totalSeconds % secondsPerMinute);

        (days, hours, minutes, seconds);
    };

};
