import alt from '../alt';

import UserFilterActions from '../actions/UserFilterActions';

class UserFiltersStore {
  constructor() {
    this.bindActions(UserFilterActions);
    this.currentProjectIds = [];
    this.previousProjectIds = [];
    this.roleIds = [];
    this.userIds = [];
  }

  changeCurrentProjectIds(projectIds) {
    this.setState({ currentProjectIds: projectIds });
  }

  changePreviousProjectIds(projectIds) {
    this.setState({ previousProjectIds: projectIds });
  }

  changeRoleIds(roleIds) {
    this.setState({ roleIds: roleIds });
  }

  changeUserIds(userIds) {
    this.setState({ userIds: userIds });
  }
}

export default alt.createStore(UserFiltersStore);
