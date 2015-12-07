import alt from '../alt';

class FilterActions {
  constructor() {
    this.generateActions(
      'changeProjectFilter',
      'changeUserFilter',
      'highlightEnding',
      'showNext',
      'highlightNotBillable'
    )
  }
}

export default alt.createActions(FilterActions);
