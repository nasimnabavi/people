import alt from '../alt';

class ProjectActions {
  constructor() {
    this.generateActions(
      'create',
      'update',
      'delete'
    )
  }
}

export default alt.createActions(ProjectActions);
