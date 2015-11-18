import alt from '../alt';

class TeamActions {
  constructor() {
    this.generateActions(
      'create',
      'update',
      'delete'
    )
  }
}

export default alt.createActions(TeamActions);
