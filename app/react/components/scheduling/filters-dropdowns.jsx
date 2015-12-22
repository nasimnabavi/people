import React, {PropTypes} from 'react';
import Select from 'react-select';
import FiltersDropdown from './filters-dropdown';
import SchedulingUserStore from '../../stores/SchedulingUserStore'
import SchedulingFilterStore from '../../stores/SchedulingFilterStore'
import SchedulingFilterActions from '../../actions/SchedulingFilterActions';

export default class FiltersDropdowns extends React.Component {
  changeUserFilter(objectIds) {
    SchedulingFilterActions.changeUserFilter(objectIds);
  }

  render() {
    const users = SchedulingUserStore.getState().users;
    const userFilerIds = SchedulingFilterStore.getState().userIds;
    return(
      <div className="filters">
        <FiltersDropdown
          className="users"
          store_objects={users}
          filter_store_ids={userFilerIds}
          changeFilterAction={this.changeUserFilter} />
      </div>
    );
  }
}
