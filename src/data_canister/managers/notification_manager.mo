import Iter "mo:base/Iter";
import Result "mo:base/Result";
import { message } "mo:base/Error";

import CanisterIds "mo:waterway-mops/product/wwl/CanisterIds";
import Enums "mo:waterway-mops/base/Enums";
import Ids "mo:waterway-mops/base/Ids";
import ICFCEnums "mo:waterway-mops/product/icfc/Enums";
import NotificationCommands "mo:waterway-mops/product/icfc/data-canister-notification-commands/NotificationCommands";
import LeagueNotificationCommands "mo:waterway-mops/product/icfc/data-canister-notification-commands/LeagueNotificationCommands";
import PlayerNotificationCommands "mo:waterway-mops/product/icfc/data-canister-notification-commands/PlayerNotificationCommands";
import LogManager "mo:waterway-mops/product/wwl/log-management/LogManager";

module {

    public class NotificationManager() {
        let logsManager = LogManager.LogManager();

        // Add all application_canister function definitions to all apps, implement and if not required then create different groups than the default notification group

        let defaultNotificationGroup : [(ICFCEnums.App, Ids.CanisterId)] = [
            (#OpenFPL, CanisterIds.OPENFPL_BACKEND_CANISTER_ID),
            (#OpenWSL, CanisterIds.OPENWSL_BACKEND_CANISTER_ID),
            (#JeffBets, CanisterIds.JEFF_BETS_BACKEND_CANISTER_ID),
        ];

        public func distributeNotification(notificationType : ICFCEnums.NotificationType, dto : NotificationCommands.Notification) : async Result.Result<(), Enums.Error> {

            try {
                switch (notificationType) {
                    case (#AddInitialFixtures) {
                        for (app in Iter.fromArray(defaultNotificationGroup)) {
                            let application_canister = actor (app.1) : actor {
                                addInitialFixtureNotification : (dto : LeagueNotificationCommands.AddInitialFixtureNotification) -> async Result.Result<(), Enums.Error>;
                            };
                            switch (dto) {
                                case (#AddInitialFixtures foundDTO) {
                                    let _ = await application_canister.addInitialFixtureNotification(foundDTO);
                                };
                                case (_) {};
                            };
                        };
                    };
                    case (#BeginSeason) {};
                    case (#BeginGameweek) {
                        for (app in Iter.fromArray(defaultNotificationGroup)) {
                            let application_canister = actor (app.1) : actor {
                                beginGameweekNotification : (dto : LeagueNotificationCommands.BeginGameweekNotification) -> async Result.Result<(), Enums.Error>;
                            };
                            switch (dto) {
                                case (#BeginGameweek foundDTO) {
                                    let _ = await application_canister.beginGameweekNotification(foundDTO);
                                };
                                case (_) {};
                            };
                        };
                    };
                    case (#CompleteGameweek) {
                        for (app in Iter.fromArray(defaultNotificationGroup)) {
                            let application_canister = actor (app.1) : actor {
                                completeGameweekNotification : (dto : LeagueNotificationCommands.CompleteGameweekNotification) -> async Result.Result<(), Enums.Error>;
                            };
                            switch (dto) {
                                case (#CompleteGameweek foundDTO) {
                                    let _ = await application_canister.completeGameweekNotification(foundDTO);
                                };
                                case (_) {};
                            };
                        };
                    };
                    case (#CompleteFixture) {
                        for (app in Iter.fromArray(defaultNotificationGroup)) {
                            let application_canister = actor (app.1) : actor {
                                finaliseFixtureNotification : (dto : LeagueNotificationCommands.CompleteFixtureNotification) -> async Result.Result<(), Enums.Error>;
                            };
                            switch (dto) {
                                case (#CompleteFixture foundDTO) {
                                    let _ = await application_canister.finaliseFixtureNotification(foundDTO);
                                };
                                case (_) {};
                            };
                        };
                    };
                    case (#FinaliseFixture) {
                        for (app in Iter.fromArray(defaultNotificationGroup)) {
                            let application_canister = actor (app.1) : actor {
                                finaliseFixtureNotification : (dto : LeagueNotificationCommands.FinaliseFixtureNotification) -> async Result.Result<(), Enums.Error>;
                            };
                            switch (dto) {
                                case (#FinaliseFixture foundDTO) {
                                    let _ = await application_canister.finaliseFixtureNotification(foundDTO);
                                };
                                case (_) {};
                            };
                        };
                    };
                    case (#CompleteSeason) {
                        for (app in Iter.fromArray(defaultNotificationGroup)) {
                            let application_canister = actor (app.1) : actor {
                                completeSeasonNotification : (dto : LeagueNotificationCommands.CompleteSeasonNotification) -> async Result.Result<(), Enums.Error>;
                            };
                            switch (dto) {
                                case (#CompleteSeason foundDTO) {
                                    let _ = await application_canister.completeSeasonNotification(foundDTO);
                                };
                                case (_) {};
                            };
                        };
                    };
                    case (#RevaluePlayerUp) {
                        for (app in Iter.fromArray(defaultNotificationGroup)) {
                            let application_canister = actor (app.1) : actor {
                                revaluePlayerUpNotification : (dto : PlayerNotificationCommands.PlayerChangeNotification) -> async Result.Result<(), Enums.Error>;
                            };
                            switch (dto) {
                                case (#RevaluePlayerUp foundDTO) {
                                    let _ = await application_canister.revaluePlayerUpNotification(foundDTO);
                                };
                                case (_) {};
                            };
                        };
                    };
                    case (#RevaluePlayerDown) {
                        for (app in Iter.fromArray(defaultNotificationGroup)) {
                            let application_canister = actor (app.1) : actor {
                                revaluePlayerDownNotification : (dto : PlayerNotificationCommands.PlayerChangeNotification) -> async Result.Result<(), Enums.Error>;
                            };
                            switch (dto) {
                                case (#RevaluePlayerDown foundDTO) {
                                    let _ = await application_canister.revaluePlayerDownNotification(foundDTO);
                                };
                                case (_) {};
                            };
                        };
                    };
                    case (#LoanPlayer) {
                        for (app in Iter.fromArray(defaultNotificationGroup)) {
                            let application_canister = actor (app.1) : actor {
                                loanPlayerNotification : (dto : PlayerNotificationCommands.PlayerChangeNotification) -> async Result.Result<(), Enums.Error>;
                            };
                            switch (dto) {
                                case (#LoanPlayer foundDTO) {
                                    let _ = await application_canister.loanPlayerNotification(foundDTO);
                                };
                                case (_) {};
                            };
                        };
                    };
                    case (#RecallPlayer) {
                        for (app in Iter.fromArray(defaultNotificationGroup)) {
                            let application_canister = actor (app.1) : actor {
                                recallPlayerNotification : (dto : PlayerNotificationCommands.PlayerChangeNotification) -> async Result.Result<(), Enums.Error>;
                            };
                            switch (dto) {
                                case (#RecallPlayer foundDTO) {
                                    let _ = await application_canister.recallPlayerNotification(foundDTO);
                                };
                                case (_) {};
                            };
                        };
                    };
                    case (#ExpireLoan) {
                        for (app in Iter.fromArray(defaultNotificationGroup)) {
                            let application_canister = actor (app.1) : actor {
                                expireLoanNotification : (dto : PlayerNotificationCommands.PlayerChangeNotification) -> async Result.Result<(), Enums.Error>;
                            };
                            switch (dto) {
                                case (#ExpireLoan foundDTO) {
                                    let _ = await application_canister.expireLoanNotification(foundDTO);
                                };
                                case (_) {};
                            };
                        };
                    };
                    case (#TransferPlayer) {
                        for (app in Iter.fromArray(defaultNotificationGroup)) {
                            let application_canister = actor (app.1) : actor {
                                transferPlayerNotification : (dto : PlayerNotificationCommands.PlayerChangeNotification) -> async Result.Result<(), Enums.Error>;
                            };
                            switch (dto) {
                                case (#TransferPlayer foundDTO) {
                                    let _ = await application_canister.transferPlayerNotification(foundDTO);
                                };
                                case (_) {};
                            };
                        };
                    };
                    case (#SetFreeAgent) {
                        for (app in Iter.fromArray(defaultNotificationGroup)) {
                            let application_canister = actor (app.1) : actor {
                                setFreeAgentNotification : (dto : PlayerNotificationCommands.PlayerChangeNotification) -> async Result.Result<(), Enums.Error>;
                            };
                            switch (dto) {
                                case (#SetFreeAgent foundDTO) {
                                    let _ = await application_canister.setFreeAgentNotification(foundDTO);
                                };
                                case (_) {};
                            };
                        };
                    };
                    case (#RetirePlayer) {
                        for (app in Iter.fromArray(defaultNotificationGroup)) {
                            let application_canister = actor (app.1) : actor {
                                retirePlayerNotification : (dto : PlayerNotificationCommands.PlayerChangeNotification) -> async Result.Result<(), Enums.Error>;
                            };
                            switch (dto) {
                                case (#RetirePlayer foundDTO) {
                                    let _ = await application_canister.retirePlayerNotification(foundDTO);
                                };
                                case (_) {};
                            };
                        };
                    };
                    case (#ChangePlayerPosition) {
                        for (app in Iter.fromArray(defaultNotificationGroup)) {
                            let application_canister = actor (app.1) : actor {
                                changePlayerPositionNotification : (dto : PlayerNotificationCommands.PlayerChangeNotification) -> async Result.Result<(), Enums.Error>;
                            };
                            switch (dto) {
                                case (#ChangePlayerPosition foundDTO) {
                                    let _ = await application_canister.changePlayerPositionNotification(foundDTO);
                                };
                                case (_) {};
                            };
                        };
                    };
                    case (#CreateClub) {};
                    case (#UpdateClub) {};
                    case (#PromoteClub) {};
                    case (#RelegateClub) {};
                    case (#CreateLeague) {};
                    case (#UpdateLeague) {};
                    case (#CreatePlayer) {};
                    case (#UpdatePlayer) {};
                    case (#InjuryUpdated) {};
                    case (#UnretirePlayer) {};
                };
            } catch (err) {
                let error : Error = err;
                let _ = await logsManager.addApplicationLog({
                    app = #FootballGod;
                    logType = #Error;
                    title = "Failure to distribute notification";
                    detail = message(error);
                    error = ?#CallFailed;

                });
            };
            return #ok();
        }

    };

};
