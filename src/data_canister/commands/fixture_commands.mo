import FootballIds "mo:waterway-mops/domain/football/Ids";
import FootballEnums "mo:waterway-mops/domain/football/Enums";
import FootballDefinitions "mo:waterway-mops/domain/football/Definitions";

module FixtureCommands {

  public type SubmitFixtureData = {
    leagueId: FootballIds.LeagueId;
    seasonId: FootballIds.SeasonId;
    fixtureId : FootballIds.FixtureId;
    gameweek: FootballDefinitions.GameweekNumber;
    playerEventData : [PlayerEventData];
  };

  public type PlayerEventData = {
    fixtureId : FootballIds.FixtureId;
    playerId : Nat16;
    eventType : FootballEnums.PlayerEventType;
    eventStartMinute : Nat8;
    eventEndMinute : Nat8;
    clubId : FootballIds.ClubId;
  };

  public type AddInitialFixtures = {
    leagueId: FootballIds.LeagueId;
    seasonId: FootballIds.SeasonId;
    seasonFixtures : [InitialFixture];
  };

  public type InitialFixture = {
    gameweek : FootballDefinitions.GameweekNumber;
    kickOff : Int;
    homeClubId : FootballIds.ClubId;
    awayClubId : FootballIds.ClubId;
  };

  public type MoveFixture = {
    leagueId: FootballIds.LeagueId;
    seasonId: FootballIds.SeasonId;
    fixtureId : FootballIds.FixtureId;
    updatedFixtureGameweek : FootballDefinitions.GameweekNumber;
    updatedFixtureDate : Int;
  };

  public type PostponeFixture = {
    leagueId: FootballIds.LeagueId;
    seasonId: FootballIds.SeasonId;
    fixtureId : FootballIds.FixtureId;
  };

  public type RescheduleFixture = {
    leagueId: FootballIds.LeagueId;
    seasonId: FootballIds.SeasonId;
    fixtureId : FootballIds.FixtureId;
    updatedFixtureGameweek : FootballDefinitions.GameweekNumber;
    updatedFixtureDate : Int;
  };
}