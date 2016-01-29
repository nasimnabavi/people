import alt from '../alt';

class FilterActions {
  constructor() {
    this.generateActions(
      'changeRoleFilter',
      'changeProjectFilter',
      'changeUserFilter',
      'highlightEnding',
      'showNext',
      'highlightNotBillable'
    )
  }
}

export default alt.createActions(FilterActions);
