import alt from '../alt';

class SchedulingFilterActions {
  constructor() {
    this.generateActions(
      'changeUserFilter',
      'changeRoleFilter',
      'changeAbilityFilter'
    )
  }
}

export default alt.createActions(SchedulingFilterActions);
