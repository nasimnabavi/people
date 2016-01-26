import alt from '../alt';

class UserFilterActions {
  constructor() {
    this.generateActions(
      'changeCurrentProjectIds',
      'changePreviousProjectIds',
      'changeRoleIds',
      'changeUserIds'
    );
  }
}

export default alt.createActions(UserFilterActions);
