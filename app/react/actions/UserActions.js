import alt from '../alt';

class UserActions {
  constructor() {
    this.generateActions(
      'addToTeam',
      'promoteToLeader',
      'removeFromTeam',
      'update'
    );
  }
}

export default alt.createActions(UserActions);
