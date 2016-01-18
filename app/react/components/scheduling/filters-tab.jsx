import React, {PropTypes} from 'react';
import SchedulingUserStore from '../../stores/SchedulingUserStore'
import SchedulingFilterStore from '../../stores/SchedulingFilterStore'

export default class FiltersTab extends React.Component {
  static get propTypes() {
    return {
      name: React.PropTypes.string.isRequired,
      filterAction: React.PropTypes.func
    };
  }

  constructor(props) {
    super(props);
    this.handleFilterChange = this.handleFilterChange.bind(this);
  }

  handleFilterChange(values) {
    this.props.filterAction();
  }

  render() {
    const users = SchedulingUserStore.getState().users;
    const userFilerIds = SchedulingFilterStore.getState().userIds;

    return(
      <li className="category">
        <a href="#" onClick={this.handleFilterChange}>
          {this.props.name}
          <span className="user-count"> ()</span>
        </a>
      </li>
    );
  }
}
