import Ids "mo:waterway-mops/base/Ids";
import FootballIds "mo:waterway-mops/domain/football/Ids";
import Enums "mo:waterway-mops/base/Enums";

module LeagueCommands {

  public type CreateLeague = {
    name: Text;
    abbreviation: Text;
    teamCount: Nat8;
    relatedGender: Enums.Gender;
    governingBody: Text;
    formed: Int;
    countryId: Ids.CountryId;
    logo: ?Blob;
  };

  public type UpdateLeague = {
    leagueId: FootballIds.LeagueId;
    name: Text;
    abbreviation: Text;
    teamCount: Nat8;
    relatedGender: Enums.Gender;
    governingBody: Text;
    formed: Int;
    countryId: Ids.CountryId;
    logo: Blob;
  };
}