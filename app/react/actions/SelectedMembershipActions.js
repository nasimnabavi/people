import alt from '../alt';

class SelectedMembershipActions {
  constructor() {
    this.generateActions(
      'editMembership',
      'cancelEditMembership'
    )
  }
}

export default alt.createActions(SelectedMembershipActions);
