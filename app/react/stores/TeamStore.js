import alt from '../alt';

import TeamActions from '../actions/TeamActions';

class TeamStore {
  constructor() {
    this.bindActions(TeamActions);
    this.teams = [];
  }

  onCreate(name) {
    const addedTeam = (data) => {
      this.teams.push(data);
      Messenger().success(`${data.name} has been created`);
      this.emitChange();
    };
    const failedToAddTeam = () => Messenger().error("Name of this team is already taken");
    $.ajax({
      url: Routes.teams_path(),
      type: "POST",
      dataType: 'json',
      data: {
        team: {
          name: name
        }
      }
    }).done(addedTeam).fail(failedToAddTeam);
    return false;
  }

  onUpdate(params) {
    const teamEdited = (data) => {
      let teamIds = this.teams.map(team => team.id);
      let editedTeamIndex = teamIds.indexOf(data.id);
      this.teams[editedTeamIndex] = data;
      Messenger().success(`Team ${data.name} changed successfully`);
      this.emitChange();
    };
    const failedToEditTeam = () => Messenger().error("Failed to edit team");
    $.ajax({
      url: Routes.team_path(params.editedTeam.id),
      type: "PUT",
      dataType: 'json',
      data: {
        team: {
          name: params.name
        }
      }
    }).done(teamEdited).fail(failedToEditTeam);
    return false;
  }

  onDelete(id) {
    const teamRemoved = () => {
      const removedTeam = this.teams.filter(team => team.id == id)[0];
      Messenger().success(`${removedTeam.name} team removed.`);
      this.teams = this.teams.filter(team => team.id != id);
      this.emitChange();
    }
    const failedToRemoveTeam = () => Messenger().error(`Team could not be removed`);
    $.ajax({
      url: Routes.team_path(id),
      type: "DELETE",
      dataType: 'json'
    }).done(teamRemoved).fail(failedToRemoveTeam);
    return false;
  }

  static setInitialState(teams) {
    this.state.teams = teams;
  }
}

export default alt.createStore(TeamStore);
