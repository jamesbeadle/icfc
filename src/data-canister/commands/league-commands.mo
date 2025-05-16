import Enums "mo:waterway-mops/base/enums";
import FootballIds "mo:waterway-mops/domain/football/ids";
import Ids "mo:waterway-mops/base/ids";

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