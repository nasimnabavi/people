import alt from '../alt';
import SchedulingFilterActions from '../actions/SchedulingFilterActions';

class SchedulingFilterStore {
  constructor() {
    this.bindActions(SchedulingFilterActions);
    this.userIds = [];
    this.roleIds = [];
    this.abilityIds = [];
  }

  changeUserFilter(userIds) {
    this.setState({ userIds: userIds });
  }

  changeRoleFilter(roleIds) {
    this.setState({ roleIds: roleIds });
  }

  changeAbilityFilter(abilityIds) {
    this.setState({ abilityIds: abilityIds });
  }
}

export default alt.createStore(SchedulingFilterStore);
