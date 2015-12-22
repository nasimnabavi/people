import alt from '../alt';

class SchedulingUserStore {
  constructor() {
    this.users = [];
  }

  static setInitialState(users) {
    this.state.users = users;
  }
}

export default alt.createStore(SchedulingUserStore);
