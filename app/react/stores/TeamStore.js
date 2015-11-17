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

  onUpdate(name) {
    // CODE
  }

  onDelete(id) {
    // CODE
  }

  static setInitialState(teams) {
    this.state.teams = teams;
  }
}

export default alt.createStore(TeamStore);
