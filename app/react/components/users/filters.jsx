import React, {PropTypes} from 'react';
import UserStore from '../../stores/UserStore';
import RoleStore from '../../stores/RoleStore';
import ProjectStore from '../../stores/ProjectStore';
import UserFilterStore from '../../stores/UserFiltersStore';
import UserFilterActions from '../../actions/UserFilterActions';
import Select from 'react-select';


export default class Filters extends React.Component {
  constructor(props) {
    super(props);
  }

  handleFilterUserChange(values) {
    let userIds = [];
    debugger;
    if(values != '') {
      userIds = values.split(',').map(value => Number(value));
    }
    UserFilterActions.changeUserIds(userIds);
  }

  handleFilterCurrentProjectsChange(values) {
    let projectIds = [];
    if(values != '') {
      projectIds = values.split(',').map(value => Number(value));
    }
    UserFilterActions.changeCurrentProjectIds(projectIds);
  }

  handleFilterPreviousProjectsChange(values) {
    let projectIds = [];
    if(values != '') {
      projectIds = values.split(',').map(value => Number(value));
    }
    UserFilterActions.changePreviousProjectIds(projectIds);
  }

  handleFilterRoleChange(values) {
    let roleIds = [];
    if(values != '') {
      roleIds = values.split(',').map(value => Number(value));
    }
    UserFilterActions.changeRoleIds(roleIds);
  }

  render() {
    const users = UserStore.getState().users;
    const roles = RoleStore.getState().roles;
    const projects = ProjectStore.getState().projects;

    const userFilterOptions = users.map(user => {
      return { label: `${user.last_name} ${user.first_name}`, value: user.id };
    });

    const roleFilterOptions = roles.map(role => {
      return { label: role.name, value: role.id }
    });

    const projectFilterOptions = projects.map(project => {
      return { label: project.name, value: project.id }
    });

    const userSelectValue = UserFilterStore.getState().userIds.map(userId => {
      const optionIds = userFilterOptions.map(option => option.value);
      let optionIndex = optionIds.indexOf(userId);
      return userFilterOptions[optionIndex];
    });

    const roleSelectValue = UserFilterStore.getState().roleIds.map(roleId => {
      const optionIds = roleFilterOptions.map(option => option.value);
      let optionIndex = optionIds.indexOf(roleId);
      return roleFilterOptions[optionIndex];
    });

    const currentProjectsSelectValue = UserFilterStore.getState().currentProjectIds.map(projectId => {
      const optionIds = projectFilterOptions.map(option => option.value);
      let optionIndex = optionIds.indexOf(projectId);
      return projectFilterOptions[optionIndex];
    });

    const previousProjectsSelectValue = UserFilterStore.getState().previousProjectIds.map(projectId => {
      const optionIds = projectFilterOptions.map(option => option.value);
      let optionIndex = optionIds.indexOf(projectId);
      return projectFilterOptions[optionIndex];
    });

    return(
      <div id="filters">
        <div className="filters">
          <div className="users">
            <Select name="users" placeholder="Filter users..." type="text"
              multi={true}
              options={userFilterOptions}
              value={userSelectValue}
              onChange={this.handleFilterUserChange} />
          </div>
          <div className="roles">
            <Select name="roles" placeholder="Filter roles..." type="text"
              multi={true}
              options={roleFilterOptions}
              value={roleSelectValue}
              onChange={this.handleFilterRoleChange} />
          </div>
          <div className="projects">
            <Select name="projects-current" placeholder="Filter by current projects..." type="text"
              multi={true}
              options={projectFilterOptions}
              value={currentProjectsSelectValue}
              onChange={this.handleFilterCurrentProjectsChange} />
          </div>
          <div className="projects">
            <Select name="projects-old" placeholder="Filter by previous projects..." type="text"
              multi={true}
              options={projectFilterOptions}
              value={previousProjectsSelectValue}
              onChange={this.handleFilterPreviousProjectsChange} />
          </div>
        </div>
      </div>
    );
  }
}

Filters.propTypes = {
};
