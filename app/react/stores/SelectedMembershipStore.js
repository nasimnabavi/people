import alt from '../alt';

import SelectedMembershipActions from '../actions/SelectedMembershipActions';

class SelectedMembershipStore {
  constructor() {
    this.bindActions(SelectedMembershipActions);
    this.membership = null;
  }

  editMembership(membership) {
    this.setState({ membership: membership });
  }

  cancelEditMembership() {
    this.setState({ membership: null });
  }
}

export default alt.createStore(SelectedMembershipStore);
