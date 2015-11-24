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
      this._defaultSort();
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
      this.teams.forEach((team, index) => {
        if(team.id === data.id) { this.teams[index] = data; }
      });
      this._defaultSort();
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
      this._defaultSort();
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

  _defaultSort() {
    this.teams.sort((a, b) => {
      return a.name.toLowerCase().localeCompare(b.name.toLowerCase());
    });
  }

  static setInitialState(teams) {
    this.state.teams = teams.sort((a, b) => {
      return a.name.toLowerCase().localeCompare(b.name.toLowerCase());
    });
  }
}

export default alt.createStore(TeamStore);
