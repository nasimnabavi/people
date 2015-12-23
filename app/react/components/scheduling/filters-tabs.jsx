import React, {PropTypes} from 'react';
import FilterTab from './filters-tab';
import SchedulingUserStore from '../../stores/SchedulingUserStore'
import SchedulingFilterStore from '../../stores/SchedulingFilterStore'
import SchedulingFilterActions from '../../actions/SchedulingFilterActions';

export default class FiltersTabs extends React.Component {
  render() {
    const filterTabs = ["All", "Juniors/Interns", "To rotate", "Internals", "Rotation in progress"].map(name => {
      return <FilterTab name={name} />;
    });

    return(
      <ul className="nav nav-tabs scheduled-users-categories">
        {filterTabs}
      </ul>
    );
  }
}
