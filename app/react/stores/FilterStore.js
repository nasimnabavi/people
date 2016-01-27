import alt from '../alt';

import FilterActions from '../actions/FilterActions';

class FilterStore {
  constructor() {
    this.bindActions(FilterActions);
    this.roleIds = [];
    this.projectIds = [];
    this.userIds = [];
    this.showNext = false;
    this.highlightEnding = false;
    this.highlightNotBillable = false;
  }

  changeRoleFilter(roleIds) {
    this.setState({ roleIds: roleIds});
  }

  changeProjectFilter(projectIds) {
    this.setState({ projectIds: projectIds});
  }

  changeUserFilter(userIds) {
    this.setState({ userIds: userIds });
  }

  highlightEnding(value) {
    this.setState({ highlightEnding: value });
  }

  showNext(value) {
    this.setState({ showNext: value });
  }

  highlightNotBillable(value) {
    this.setState({ highlightNotBillable: value });
  }
}

export default alt.createStore(FilterStore);
