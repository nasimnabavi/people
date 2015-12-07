import alt from '../alt';

import UserActions from '../actions/UserActions';
import UserSource from '../sources/UserSource';

class UserStore {
  constructor() {
    this.bindActions(UserActions);
    this.users = [];
  }


  addToTeam(params) {
    let user = this.users.filter(user => user.id == params.userId)[0];
    let userIndex = this.users.indexOf(user);
    if(user.team_ids === null) {
      user.team_ids = [params.teamId];
    } else { user.team_ids.push(params.teamId) };
    let userPersisted = () => {
      Messenger().success(`User ${user.name} added to team`);
      this.users[userIndex] = user;
      this.emitChange();
    };
    let failedToAddUserToTeam = () => {
      Messenger().success(`Failed to add user ${user.name} to team`);
    }
    this._updateUser(user, userPersisted, failedToAddUserToTeam);
    return false;
  }

  _updateUser(user, onSuccess, onFail) {
    $.ajax({
      url: Routes.user_path(user.id),
      type: "PUT",
      dataType: 'json',
      data: {
        user: {
          team_ids: user.team_ids
        }
      }
    }).done(onSuccess).fail(onFail);
  }

  update(params) {
    const successCallback = (data) => {
      const userIndex = this.users.map(user => user.id).indexOf(data.id);
      Messenger().success('User updated successfully.');
      this.users[userIndex] = data;
      this.emitChange();
    };
    const failCallback = () => {
      Messenger().error('Failed to update user');
      this.emitChange();
    };
    UserSource.update(params).done(successCallback).fail(failCallback);
    return false;
  }

  promoteToLeader(team_id) {
    // CODE
  }

  removeFromTeam(team_id) {
    // CODE
  }

  static setInitialState(users) {
    this.state.users = users;
  }
}

export default alt.createStore(UserStore);
