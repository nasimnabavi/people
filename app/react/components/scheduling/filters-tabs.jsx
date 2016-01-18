import React, {PropTypes} from 'react';
import FilterTab from './filters-tab';
import SchedulingUserStore from '../../stores/SchedulingUserStore'
import SchedulingFilterStore from '../../stores/SchedulingFilterStore'
import SchedulingFilterActions from '../../actions/SchedulingFilterActions';

export default class FiltersTabs extends React.Component {
  render() {
    let filterActions = [
      { key: 1, name: "All", action: SchedulingFilterActions.showAll },
      { key: 2, name: "Juniors/Interns", action: SchedulingFilterActions.showJuniorsAndInterns },
      { key: 3, name: "To rotate", action: SchedulingFilterActions.showToRotate },
      { key: 4, name: "Internals", action: SchedulingFilterActions.showInternals },
      { key: 5, name: "Rotation in progress", action: SchedulingFilterActions.showInRotation },
      { key: 6, name: "Unavailable", action: SchedulingFilterActions.showUnavailable }
    ];

    if(this.props.showHidden)
        filterActions.push({ key: 7, name: "Not Scheduled", action: SchedulingFilterActions.showNotScheduled })

    const filterTabs = filterActions.map(filterAction => {
      return <FilterTab key={filterAction.key} name={filterAction.name} filterAction={filterAction.action} />;
    });

    return(
      <ul className="nav nav-tabs scheduled-users-categories">
        {filterTabs}
      </ul>
    );
  }
}
