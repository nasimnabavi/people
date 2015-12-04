import alt from '../alt';

class ProjectUsersActions {
  constructor() {
    this.generateActions(
      'create',
      'update',
      'delete'
    )
  }
}

export default alt.createActions(ProjectUsersActions);
