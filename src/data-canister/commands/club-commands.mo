import Enums "mo:waterway-mops/base/enums";
import FootballIds "mo:waterway-mops/domain/football/ids";
import FootballEnums "mo:waterway-mops/domain/football/enums";

module ClubCommands {

  public type CreateClub = {
    leagueId: FootballIds.LeagueId;
    name : Text;
    friendlyName : Text;
    primaryColourHex : Text;
    secondaryColourHex : Text;
    thirdColourHex : Text;
    abbreviatedName : Text;
    shirtType : FootballEnums.ShirtType;
    gender: Enums.Gender;
  };
  
  public type UpdateClub = {
    leagueId: FootballIds.LeagueId;
    clubId : FootballIds.ClubId;
    name : Text;
    friendlyName : Text;
    primaryColourHex : Text;
    secondaryColourHex : Text;
    thirdColourHex : Text;
    abbreviatedName : Text;
    shirtType : FootballEnums.ShirtType;
  };

  public type PromoteClub = {
    leagueId: FootballIds.LeagueId;
    clubId: FootballIds.ClubId;
    toLeagueId: FootballIds.LeagueId;
  };

  public type RelegateClub = {
    leagueId: FootballIds.LeagueId;
    clubId: FootballIds.ClubId;
    relegatedToLeagueId: FootballIds.LeagueId;
  };
}