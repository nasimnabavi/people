import alt from '../alt';

class MembershipActions {
  constructor() {
    this.generateActions(
      'create',
      'update',
      'delete'
    )
  }
}

export default alt.createActions(MembershipActions);
