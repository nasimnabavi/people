import alt from '../alt';
import SchedulingFilterActions from '../actions/SchedulingFilterActions';
import * as FilterTabs from '../constants/scheduling/FilterTabs';

class SchedulingFilterStore {
  constructor() {
    this.bindActions(SchedulingFilterActions);
    this.userIds = [];
    this.roleIds = [];
    this.abilityIds = [];
    this.currentTab = 'All'
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

  showAll(){
    this.setState({ currentTab: FilterTabs.ALL});
  }

  showJuniorsAndInterns(){
    this.setState({ currentTab: FilterTabs.JUNIORS_AND_INTERNS});
  }

  showToRotate(){
    this.setState({ currentTab: FilterTabs.TO_ROTATE});
  }

  showInternals() {
    this.setState({ currentTab: FilterTabs.INTERNALS});
  }

  showInRotation(){
    this.setState({ currentTab: FilterTabs.IN_ROTATION});
  }

  showInCommercialProjectsWithDueDate() {
    this.setState({ currentTab: FilterTabs.IN_COMMERCIAL_PROJECTS_WITH_DUE_DATE});
  }

  showBooked(){
    this.setState({ currentTab: FilterTabs.BOOKED});
  }

  showUnavailable(){
    this.setState({ currentTab: FilterTabs.UNAVAILABLE});
  }

  showNotScheduled(){
    this.setState({ currentTab: FilterTabs.NOT_SCHEDULED});
  }
}

export default alt.createStore(SchedulingFilterStore);
