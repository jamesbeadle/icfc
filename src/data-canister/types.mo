import List "mo:base/List";

import Definitions "mo:waterway-mops/base/definitions";
import Enums "mo:waterway-mops/base/enums";
import FootballIds "mo:waterway-mops/domain/football/ids";
import FootballEnums "mo:waterway-mops/domain/football/enums";
import FootballDefinitions "mo:waterway-mops/domain/football/definitions";
import Ids "mo:waterway-mops/base/ids";

module FootballTypes {

  public type League = {
    id : FootballIds.LeagueId;
    name : Text;
    abbreviation : Text;
    teamCount : Nat8;
    relatedGender : Enums.Gender;
    governingBody : Text;
    formed : Int;
    countryId : Ids.CountryId;
    logo : Blob;
  };

  public type LeagueStatus = {
    leagueId : FootballIds.LeagueId;
    activeSeasonId : FootballIds.SeasonId;
    activeMonth : Definitions.CalendarMonth;
    unplayedGameweek : FootballDefinitions.GameweekNumber;
    activeGameweek : FootballDefinitions.GameweekNumber;
    completedGameweek : FootballDefinitions.GameweekNumber;
    transferWindowActive : Bool;
    seasonActive : Bool;
    totalGameweeks : Nat8;
    transferWindowStartDay : Nat8;
    transferWindowStartMonth : Nat8;
    transferWindowEndDay : Nat8;
    transferWindowEndMonth : Nat8;
  };

  public type Season = {
    id : Nat16;
    name : Text;
    year : Nat16;
    fixtures : List.List<Fixture>;
    postponedFixtures : List.List<Fixture>;
  };

  public type Fixture = {
    id : FootballIds.FixtureId;
    seasonId : FootballIds.SeasonId;
    gameweek : FootballDefinitions.GameweekNumber;
    kickOff : Int;
    homeClubId : FootballIds.ClubId;
    awayClubId : FootballIds.ClubId;
    homeGoals : Nat8;
    awayGoals : Nat8;
    status : FootballEnums.FixtureStatusType;
    highestScoringPlayerId : FootballIds.PlayerId;
    events : List.List<PlayerEventData>;
  };

  public type FootballClub = {
    id : FootballIds.ClubId;
    name : Text;
    friendlyName : Text;
    gender: Enums.Gender;
    primaryColourHex : Text;
    secondaryColourHex : Text;
    thirdColourHex : Text;
    abbreviatedName : Text;
    shirtType : FootballEnums.ShirtType;
  };

  public type Player = {
    id : FootballIds.PlayerId;
    leagueId : FootballIds.LeagueId;
    clubId : FootballIds.ClubId;
    position : FootballEnums.PlayerPosition;
    firstName : Text;
    lastName : Text;
    shirtNumber : Nat8;
    valueQuarterMillions : Nat16;
    dateOfBirth : Int;
    nationality : Ids.CountryId;
    seasons : List.List<PlayerSeason>;
    valueHistory : List.List<ValueHistory>;
    status : FootballEnums.PlayerStatus;
    currentLoanEndDate : Int;
    parentLeagueId : FootballIds.LeagueId;
    parentClubId : FootballIds.ClubId;
    latestInjuryEndDate : Int;
    injuryHistory : List.List<InjuryHistory>;
    transferHistory : List.List<TransferHistory>;
    retirementDate : Int;
    gender : Enums.Gender;
  };

  public type PlayerSeason = {
    id : FootballIds.SeasonId;
    gameweeks : List.List<PlayerGameweek>;
    totalPoints : Int16;
  };

  public type PlayerGameweek = {
    number : FootballDefinitions.GameweekNumber;
    events : List.List<PlayerEventData>;
    points : Int16;
  };

  public type PlayerEventData = {
    fixtureId : FootballIds.FixtureId;
    playerId : Nat16;
    eventType : FootballEnums.PlayerEventType;
    eventStartMinute : Nat8;
    eventEndMinute : Nat8;
    clubId : FootballIds.ClubId;
  };

  public type ValueHistory = {
    changedOn : Int;
    oldValue : Nat16;
    newValue : Nat16;
  };

  public type InjuryHistory = {
    description : Text;
    injuryStartDate : Int;
    expectedEndDate : Int;
  };

  public type TransferHistory = {
    transferDate : Int;
    fromLeagueId : FootballIds.LeagueId;
    toLeagueId : FootballIds.LeagueId;
    fromClub : FootballIds.ClubId;
    toClub : FootballIds.ClubId;
    loanEndDate : Int;
  };

  public type LeagueTable = {
    leagueId : FootballIds.LeagueId;
    seasonId : FootballIds.SeasonId;
    entries : [LeagueTableEntry];
  };

  public type LeagueTableEntry = {
    position : Nat;
    clubId : FootballIds.ClubId;
    played : Nat;
    won : Nat;
    drawn : Nat;
    lost : Nat;
    conceded : Nat;
    scored : Nat;
    points : Nat;
    homePlayed : Nat;
    homeWon : Nat;
    homeDrawn : Nat;
    homeLost : Nat;
    homeConceded : Nat;
    homeScored : Nat;
    homePoints : Nat;
    awayPlayed : Nat;
    awayWon : Nat;
    awayDrawn : Nat;
    awayLost : Nat;
    awayConceded : Nat;
    awayScored : Nat;
    awayPoints : Nat;
  };

    public type ClubSummary = {
        clubId: FootballIds.ClubId;
        leagueId: FootballIds.LeagueId;
        clubName: Text;
        position: Nat;
        positionText: Text;
        totalValue: Nat;
        priorValue: Nat;
        primaryColour: Text;
        secondaryColour: Text;
        thirdColour: Text;
        shirtType: FootballEnums.ShirtType;
        gender: Enums.Gender;
        totalPlayers: Nat16;
        totalGoalkeepers: Nat16;
        totalDefenders: Nat16;
        totalMidfielders: Nat16;
        totalForwards: Nat16;
        totalGKValue: Nat;
        totalDFValue: Nat;
        totalMFValue: Nat;
        totalFWValue: Nat;
        mvp: MostValuablePlayer;
    };

    public type MostValuablePlayer = {
        id: FootballIds.PlayerId;
        firstName: Text;
        lastName: Text;
        value: Nat16;
    };

    public type PlayerSummary = {
        playerId: FootballIds.PlayerId;
        clubId: FootballIds.ClubId;
        leagueId: FootballIds.LeagueId;
        position: Nat;
        positionText: Text;
        totalValue: Nat16;
        priorValue: Nat16;
    };

    public type DataTotals = {
        totalLeagues: Nat;
        totalClubs: Nat;
        totalPlayers: Nat;
    };

};
