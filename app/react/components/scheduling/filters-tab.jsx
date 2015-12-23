import React, {PropTypes} from 'react';
import SchedulingUserStore from '../../stores/SchedulingUserStore'
import SchedulingFilterStore from '../../stores/SchedulingFilterStore'
import SchedulingFilterActions from '../../actions/SchedulingFilterActions';

export default class FiltersTab extends React.Component {
  static get propTypes() {
    return {
      name: React.PropTypes.string.isRequired
    };
  }

  constructor(props) {
    super(props);
    this.handleFilterChange = this.handleFilterChange.bind(this);
  }

  handleFilterChange(values) {
    let objectIds = [];
    SchedulingFilterActions.changeUserFilter(objectIds);
  }

  render() {
    const users = SchedulingUserStore.getState().users;
    const userFilerIds = SchedulingFilterStore.getState().userIds;

    return(
      <li className="category">
        <a href="#">
          {this.props.name}
          <span className="user-count"> ()</span>
        </a>
      </li>
    );
  }
}
