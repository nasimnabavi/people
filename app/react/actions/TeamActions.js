import alt from '../alt';

class TeamActions {
  constructor() {
    this.generateActions(
      'create',
      'update',
      'delete',
      'setInitialTeams'
    )
  }
}

export default alt.createActions(TeamActions);
