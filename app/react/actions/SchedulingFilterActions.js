import alt from '../alt';

class SchedulingFilterActions {
  constructor() {
    this.generateActions(
      'changeUserFilter',
      'changeRoleFilter',
      'changeAbilityFilter',
      'showAll',
      'showJuniorsAndInterns',
      'showToRotate',
      'showInternals',
      'showInRotation',
      'showUnavailable'
    )
  }
}

export default alt.createActions(SchedulingFilterActions);
