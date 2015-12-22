import alt from '../alt';

class AbilityStore {
  constructor() {
    this.abilities = [];
  }

  static setInitialState(abilities) {
    this.state.abilities = abilities;
  }
}

export default alt.createStore(AbilityStore);
