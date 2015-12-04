import React, {PropTypes} from 'react';
import Select from 'react-select';
import ProjectStore from '../../stores/ProjectStore';
import ProjectUsersStore from '../../stores/ProjectUsersStore';
import FilterStore from '../../stores/FilterStore';
import FilterActions from '../../actions/FilterActions';

export default class ProjectFilters extends React.Component {
  constructor(props) {
    super(props);
    this.handleFilterProjectChange = this.handleFilterProjectChange.bind(this);
    this.handleFilterUserChange = this.handleFilterUserChange.bind(this);
  }

  handleFilterProjectChange(values) {
    let projectIds = [];
    if(values != '') {
      projectIds = values.split(',').map(value => Number(value));
    }
    FilterActions.changeProjectFilter(projectIds);
  }

  handleFilterUserChange(values) {
    let userIds = [];
    if(values != '') {
      userIds = values.split(',').map(value => Number(value));
    }
    FilterActions.changeUserFilter(userIds);
  }

  render() {
    const projects = ProjectStore.getState().projects;
    const users = ProjectUsersStore.getState().users;

    const projectFilterOptions = projects.map(project => {
      return { label: project.name, value: project.id };
    });
    const userFilterOptions = users.map(user => {
      return { label: `${user.last_name} ${user.first_name}`, value: user.id };
    });

    const projectSelectValue = FilterStore.getState().projectIds.map(projectId => {
      const optionIds = projectFilterOptions.map(option => option.value);
      let optionIndex = optionIds.indexOf(projectId);
      return projectFilterOptions[optionIndex];
    });

    const userSelectValue = FilterStore.getState().userIds.map(userId => {
      const optionIds = userFilterOptions.map(option => option.value);
      let optionIndex = optionIds.indexOf(userId);
      return userFilterOptions[optionIndex];
    });

    const highlightEndingChanged = (e) => {
      FilterActions.highlightEnding(e.target.checked);
    }

    const showNextChanged = (e) => {
      FilterActions.showNext(e.target.checked);
    }

    const highlightNonBillableChanged = (e) => {
      FilterActions.highlightNotBillable(e.target.checked);
    }


    return(
      <div id="filters">
        <div className="filters">
          <div className="filter roles hidden">
            <input type='text' name='roles' placeholder='Filter roles...'/>
          </div>
          <div className="filter projects">
            <Select
              name="filter-projects"
              placeholder="Filter projects..."
              multi={true}
              value={projectSelectValue}
              options={projectFilterOptions}
              onChange={this.handleFilterProjectChange} />
          </div>
          <div className="filter users">
            <Select
              name="filter-users"
              placeholder="Filter users..."
              multi={true}
              value={userSelectValue}
              options={userFilterOptions}
              onChange={this.handleFilterUserChange} />
          </div>
        </div>
        <div className="checkboxes">
          <div className="checkbox">
            <label>
              <input id="highlight-ending" type="checkbox" onChange={highlightEndingChanged} />
              Highlight ending
            </label>
          </div>
          <div className="checkbox">
            <label>
              <input id="show-next" type='checkbox' onChange={showNextChanged} />
              Show next
            </label>
          </div>
          <div className="checkbox">
            <label>
              <input id="highlight-not-billable" type= 'checkbox' onChange={highlightNonBillableChanged} />
              Highlight not billable
            </label>
          </div>
        </div>
      </div>
    );
  }
}

ProjectFilters.propTypes = {
};
