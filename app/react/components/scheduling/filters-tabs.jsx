import React, {PropTypes} from 'react';
import FilterTab from './filters-tab';
import SchedulingUserStore from '../../stores/SchedulingUserStore'
import SchedulingFilterStore from '../../stores/SchedulingFilterStore'
import SchedulingFilterActions from '../../actions/SchedulingFilterActions';
import * as FilterTabs from '../../constants/scheduling/FilterTabs';

export default class FiltersTabs extends React.Component {
  render() {
    let filterActions = [
      {
        key: 1, name: "All",
        href: FilterTabs.ALL,
        number: this.props.stats.all
      },
      {
        key: 2, name: "Juniors/Interns",
        href: FilterTabs.JUNIORS_AND_INTERNS,
        number: this.props.stats.juniors_and_interns
      },
      {
        key: 3, name: "To rotate",
        href: FilterTabs.TO_ROTATE,
        number: this.props.stats.to_rotate
      },
      {
        key: 4, name: "Internals",
        href: FilterTabs.INTERNALS,
        number: this.props.stats.in_internals
      },
      {
        key: 5, name: "Rotation in progress",
        href: FilterTabs.IN_ROTATION,
        number: this.props.stats.with_rotations_in_progress
      },
      {
        key: 6, name: 'In commercial project with due date',
        href: FilterTabs.IN_COMMERCIAL_PROJECTS_WITH_DUE_DATE,
        number: this.props.stats.in_commercial_projects_with_due_date
      },
      {
        key: 7, name: 'Booked',
        href: FilterTabs.BOOKED,
        number: this.props.stats.booked
      },
      {
        key: 8, name: "Unavailable",
        href: FilterTabs.UNAVAILABLE,
        number: this.props.stats.unavailable
      }
    ];

    if(this.props.showHidden) {
      filterActions.push({
        key: 9, name: "Not Scheduled",
        href: FilterTabs.NOT_SCHEDULED,
        number: this.props.stats.not_scheduled
      })
    }

    const filterTabs = filterActions.map(filterAction => {
      return <FilterTab key={filterAction.key} name={filterAction.name} href={filterAction.href} number={filterAction.number} currentTab={this.props.currentTab} />;
    });

    return(
      <ul className="nav nav-tabs scheduled-users-categories">
        {filterTabs}
      </ul>
    );
  }
}
