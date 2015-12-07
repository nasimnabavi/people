import alt from '../alt';

import UserFilterActions from '../actions/UserFilterActions';

class UserFiltersStore {
  constructor() {
    this.bindActions(UserFilterActions);
    this.actualProjectIds = [];
    this.previousProjectIds = [];
    this.roleIds = [];
    this.userIds = [];
  }

  changeActualProjectIds(projectIds) {
    this.setState({ actualProjectIds: projectIds });
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
