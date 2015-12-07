import alt from '../alt';

class RoleStore {
  constructor() {
    this.roles = [];
  }

  static setInitialState(roles) {
    this.state.roles = roles;
  }
}

export default alt.createStore(RoleStore);
