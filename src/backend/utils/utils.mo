import Nat64 "mo:base/Nat64";
import Hash "mo:base/Hash";
import Text "mo:base/Text";
import Int64 "mo:base/Int64";
import Principal "mo:base/Principal";
import Float "mo:base/Float";
import Nat32 "mo:base/Nat32";
import Nat16 "mo:base/Nat16";
import Nat8 "mo:base/Nat8";
import Iter "mo:base/Iter";
import Time "mo:base/Time";
import Management "management";
import Cycles "mo:base/ExperimentalCycles";
import Int "mo:base/Int";
import Char "mo:base/Char";
import Array "mo:base/Array";
import T "../icfc_types";
import SNSGovernance "../sns-wrappers/governance";

module Utils {
    public let getHour = func() : Nat {
        return 1_000_000_000 * 60 * 60;
    };

    public let eqNat8 = func(a : Nat8, b : Nat8) : Bool {
        a == b;
    };

    public let hashNat8 = func(key : Nat8) : Hash.Hash {
        Nat32.fromNat(Nat8.toNat(key) % (2 ** 32 - 1));
    };

    public let eqNat16 = func(a : Nat16, b : Nat16) : Bool {
        a == b;
    };

    public let hashNat16 = func(key : Nat16) : Hash.Hash {
        Nat32.fromNat(Nat16.toNat(key) % (2 ** 32 - 1));
    };

    public let eqNat32 = func(a : Nat32, b : Nat32) : Bool {
        a == b;
    };

    public let hashNat32 = func(key : Nat32) : Hash.Hash {
        Nat32.fromNat(Nat32.toNat(key) % (2 ** 32 - 1));
    };

    public let eqNat = func(a : Nat, b : Nat) : Bool {
        a == b;
    };

    public let hashNat = func(key : Nat) : Hash.Hash {
        Nat32.fromNat(key % (2 ** 32 - 1));
    };

    public func unixTimeToMonth(unixTime : Int) : Nat8 {

        let secondsInADay = 86400;
        let seconds = unixTime / 1000000000;
        var days = seconds / secondsInADay;

        var years = 1970;
        var dayCounter = days;
        label leapLoop while (dayCounter > 365) {
            if (years % 4 == 0 and (years % 100 != 0 or years % 400 == 0) and dayCounter > 366) {
                dayCounter -= 366;
            } else {
                dayCounter -= 365;
            };
            years += 1;
        };

        var dayOfYear : Int = dayCounter + 1;
        if (dayOfYear == 366) {
            dayOfYear := 1;
        };

        var isLeapYear = false;
        if (years % 4 == 0) {
            if (years % 100 != 0) {
                isLeapYear := true;
            } else if (years % 400 == 0) {
                isLeapYear := true;
            };
        };

        var monthEnds : [Nat] = [];

        if (isLeapYear) {
            monthEnds := [31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366];
        } else {
            monthEnds := [31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365];
        };

        var month = 0;
        label monthLoop for (m in Iter.range(0, 11)) {
            month += 1;
            if (dayOfYear <= monthEnds[m]) {
                break monthLoop;
            };
        };

        return Nat8.fromNat(month);
    };

    public func calculateAgeFromUnix(dobUnix : Int) : Nat {
        let secondsInADay : Int = 86_400;
        let currentUnixTime : Int = Time.now();

        let currentDays : Int = currentUnixTime / (1_000_000_000 * secondsInADay);
        let dobDays : Int = dobUnix / (1_000_000_000 * secondsInADay);

        let currentYear : Int = getYear(currentDays);
        let dobYear : Int = getYear(dobDays);

        let currentDayOfYear : Int = getDayOfYear(currentDays, currentYear);
        let dobDayOfYear : Int = getDayOfYear(dobDays, dobYear);

        var age : Int = currentYear - dobYear;
        if (currentDayOfYear < dobDayOfYear) {
            age := age - 1;
        };

        return Nat64.toNat(Int64.toNat64(Int64.fromInt(age)));

    };

    private func getYear(days : Int) : Int {
        var years = 1970;
        var dayCounter = days;
        label leapLoop while (dayCounter > 365) {
            if (years % 4 == 0 and (years % 100 != 0 or years % 400 == 0) and dayCounter > 366) {
                dayCounter -= 366;
            } else {
                dayCounter -= 365;
            };
            years += 1;
        };
        return years;
    };

    private func getDayOfYear(days : Int, year : Int) : Int {
        var dayCounter = days;
        for (y in Iter.range(1970, year - 1)) {
            if (y % 4 == 0 and (y % 100 != 0 or y % 400 == 0)) {
                dayCounter -= 366; // Leap year
            } else {
                dayCounter -= 365; // Non-leap year
            };
        };
        return dayCounter;
    };

    public func nextUnixTimeForDayOfYear(dayOfYear : Int) : Int {
        let currentUnixTime : Int = Time.now();
        let secondsInADay = 86400;
        let seconds = currentUnixTime / 1000000000;
        var days = seconds / secondsInADay;

        var years = 1970;
        var dayCounter = days;
        while (dayCounter > 365) {
            if (years % 4 == 0 and (years % 100 != 0 or years % 400 == 0) and dayCounter >= 366) {
                dayCounter -= 366;
            } else {
                dayCounter -= 365;
            };
            years += 1;
        };

        var currentDayOfYear : Int = dayCounter + 1;

        var isCurrentYearLeap = false;
        if (years % 4 == 0) {
            if (years % 100 != 0) {
                isCurrentYearLeap := true;
            } else if (years % 400 == 0) {
                isCurrentYearLeap := true;
            };
        };

        var daysTillNextInstance : Int = 0;

        if (currentDayOfYear == dayOfYear) {
            if (isCurrentYearLeap) {
                daysTillNextInstance := 366;
            } else {
                daysTillNextInstance := 365;
            };
        } else if (currentDayOfYear > dayOfYear) {
            let nextYear : Int = years + 1;
            var isNextYearLeap = false;
            if (nextYear % 4 == 0) {
                if (nextYear % 100 != 0) {
                    isNextYearLeap := true;
                } else if (nextYear % 400 == 0) {
                    isNextYearLeap := true;
                };
            };
            if (isNextYearLeap) {
                daysTillNextInstance := 366 - currentDayOfYear + dayOfYear;
            } else {
                daysTillNextInstance := 365 - currentDayOfYear + dayOfYear;
            };
        } else {
            daysTillNextInstance := dayOfYear - currentDayOfYear;
        };

        let nextInstanceUnixTime : Int = currentUnixTime + daysTillNextInstance * 1_000_000_000 * secondsInADay;
        return nextInstanceUnixTime;
    };

    public func validateHexColor(hex : Text) : Bool {

        if (Text.size(hex) != 7 or not Text.startsWith(hex, #text "#")) {
            return false;
        };

        let hexChars = "0123456789abcdefABCDEF";
        let strippedHex = switch (Text.stripStart(hex, #text "#")) {
            case (?h) h;
            case null hex;
        };

        for (char in Text.toIter(strippedHex)) {
            if (not Text.contains(hexChars, #char char)) {
                return false;
            };
        };

        return true;
    };

    public func nat64Percentage(amount : Nat64, percentage : Float) : Nat64 {
        return Int64.toNat64(Float.toInt64(Float.fromInt64(Int64.fromNat64(amount)) * percentage));
    };

    public func updateCanister_(a : actor {}, backendCanisterController : ?Principal, IC : Management.Management) : async () {
        let cid = { canister_id = Principal.fromActor(a) };
        switch (backendCanisterController) {
            case (null) {};
            case (?controller) {
                await (
                    IC.update_settings({
                        canister_id = cid.canister_id;
                        settings = {
                            controllers = ?[controller];
                            compute_allocation = ?1;
                            memory_allocation = null;
                            freezing_threshold = ?2_592_000;
                            reserved_cycles_limit = null;
                        };
                        sender_canister_version = null;
                    })
                );
            };
        };
    };

    public func topup_canister_(a : actor {}, backendCanisterController : ?Principal, IC : Management.Management, cycles : Nat) : async () {
        let cid = { canister_id = Principal.fromActor(a) };
        switch (backendCanisterController) {
            case (null) {};
            case (?_) {
                Cycles.add<system>(cycles);
                await (
                    IC.deposit_cycles({
                        canister_id = cid.canister_id;
                    })
                );
            };
        };
    };

    public func delete_canister_(a : actor {}, backendCanisterController : ?Principal, IC : Management.Management) : async () {
        let cid = { canister_id = Principal.fromActor(a) };
        switch (backendCanisterController) {
            case (null) {};
            case (?_) {
                await (
                    IC.delete_canister({
                        canister_id = cid.canister_id;
                    })
                );
            };
        };
    };

    public func getReadableDate(date : Int) : Text {
        let secondsInADay : Int = 86_400;
        let days = date / (1_000_000_000 * secondsInADay);

        let year = getYear(days);
        let dayOfYear = getDayOfYear(days, year);

        let isLeapYear = if (year % 4 == 0 and (year % 100 != 0 or year % 400 == 0)) {
            true;
        } else {
            false;
        };

        let monthEnds = if (isLeapYear) {
            [31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366];
        } else {
            [31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365];
        };

        var month = 0;
        var day = dayOfYear;

        label monthLoop for (m in Iter.range(0, 11)) {
            if (day <= monthEnds[m]) {
                month := m + 1;
                if (m > 0) {
                    day := day - monthEnds[m - 1];
                };
                break monthLoop;
            };
        };

        let monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        return Text.concat(Text.concat(Text.concat(Int.toText(day), " "), monthNames[month - 1]), Text.concat(" ", Int.toText(year)));
    };

    public func toLowercase(t : Text.Text) : Text.Text {
        func charToLower(c : Char) : Char {
            if (Char.isUppercase(c)) {
                Char.fromNat32(Char.toNat32(c) + 32);
            } else {
                c;
            };
        };
        Text.map(t, charToLower);
    };

    public func trimStartToLength(t : Text, length : Nat) : Text {
        let cs = Text.toIter(t);
        var result = "";
        var count = 0;

        label charLoop for (c in cs) {
            if (count < length) {
                result #= Text.fromChar(c);
                count += 1;
            } else {
                break charLoop;
            };
        };

        return result;
    };
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

    public func getMembershipExpirationDate(membershipType : T.MembershipType) : Int {
        let now = Time.now();
        switch (membershipType) {
            case (#Monthly) { now + (30 * 24 * 60 * 60 * 1_000_000_000) };
            case (#Seasonal) { now + (365 * 24 * 60 * 60 * 1_000_000_000) };
            case (#Lifetime) {
                now + (100 * 365 * 24 * 60 * 60 * 1_000_000_000);
            };
            case (#Founding) {
                now + (1000 * 365 * 24 * 60 * 60 * 1_000_000_000);
            };
            case (#NotClaimed) { now };
            case (#Expired) { now };
            case (#NotEligible) { now };
        };
    };

    public func convertSecondsToYears(seconds : Int) : Float {
        let secondsInAYear = 31_536_000;
        Float.fromInt(seconds) / Float.fromInt(secondsInAYear);
    };

    public func getMembershipType(neurons : [SNSGovernance.Neuron]) : T.EligibleMembership {

        var eligibleNeuronIdds : [SNSGovernance.NeuronId] = [];

        let icfc_e8s : Nat64 = 100_000_000;
        let oneK_ICFC_e8s : Nat64 = 1_000 * icfc_e8s;
        let tenK_ICFC_e8s : Nat64 = 10_000 * icfc_e8s;
        let hundredK_ICFC_e8s : Nat64 = 100_000 * icfc_e8s;
        let million_ICFC_e8s : Nat64 = 1_000_000 * icfc_e8s;

        let padding : Nat64 = 5_000_000;

        var total_staked : Nat64 = 0;

        for (neuron in neurons.vals()) {
            switch (neuron.dissolve_state) {
                case (?dissolve_state) {
                    switch (dissolve_state) {
                        case (#DissolveDelaySeconds(dissolve_delay)) {
                            if (convertSecondsToYears(Int64.toInt(Int64.fromNat64(dissolve_delay))) > 2.0) {
                                total_staked += neuron.cached_neuron_stake_e8s;
                                switch (neuron.id) {
                                    case (?id) {
                                        eligibleNeuronIdds := Array.append<SNSGovernance.NeuronId>([id], eligibleNeuronIdds);
                                    };
                                    case null {};
                                };
                            };
                        };
                        case (#WhenDissolvedTimestampSeconds(_)) {

                        };
                    };
                };

                case (null) {

                };
            };
        };

        if (total_staked + padding >= million_ICFC_e8s) {
            let dto : T.EligibleMembership = {
                membershipType = #Founding;
                eligibleNeuronIds = eligibleNeuronIdds;
            };
            return dto;
        } else if (total_staked + padding >= hundredK_ICFC_e8s) {
            let dto : T.EligibleMembership = {
                membershipType = #Lifetime;
                eligibleNeuronIds = eligibleNeuronIdds;
            };
            return dto;
        } else if (total_staked + padding >= tenK_ICFC_e8s) {
            let dto : T.EligibleMembership = {
                membershipType = #Seasonal;
                eligibleNeuronIds = eligibleNeuronIdds;
            };
            return dto;
        } else if (total_staked + padding >= oneK_ICFC_e8s) {
            let dto : T.EligibleMembership = {
                membershipType = #Monthly;
                eligibleNeuronIds = eligibleNeuronIdds;
            };
            return dto;
        } else {
            let dto : T.EligibleMembership = {
                membershipType = #NotEligible;
                eligibleNeuronIds = [];
            };
            return dto;
        };
    };

    public func isUsernameValid(username : Text) : Bool {
        if (Text.size(username) < 5 or Text.size(username) > 20) {
            return false;
        };

        let isAlphanumeric = func(s : Text) : Bool {
            let chars = Text.toIter(s);
            for (c in chars) {
                if (not ((c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or (c >= '0' and c <= '9') or (c == ' '))) {
                    return false;
                };
            };
            return true;
        };

        if (not isAlphanumeric(username)) {
            return false;
        };
        return true;
    };

};
