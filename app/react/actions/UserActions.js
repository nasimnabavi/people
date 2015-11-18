import alt from '../alt';

class UserActions {
  constructor() {
    this.generateActions(
      'addToTeam',
      'promoteToLeader',
      'removeFromTeam'
    );
  }
}

export default alt.createActions(UserActions);
