import alt from '../alt';

class UserFilterActions {
  constructor() {
    this.generateActions(
      'changeActualProjectIds',
      'changePreviousProjectIds',
      'changeRoleIds',
      'changeUserIds'
    );
  }
}

export default alt.createActions(UserFilterActions);
