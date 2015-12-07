import React, {PropTypes} from 'react';
import ProjectFilters from './project-filters';
import Project from './project';
import ProjectStore from '../../stores/ProjectStore';
import MembershipStore from '../../stores/MembershipStore'
import ProjectUsersStore from '../../stores/ProjectUsersStore';
import ProjectActions from '../../actions/ProjectActions';
import SelectedMembershipStore from '../../stores/SelectedMembershipStore';
import EditMembershipModal from './edit-membership-modal';
import FilterStore from '../../stores/FilterStore';


export default class Projects extends React.Component {
  constructor(props) {
    super(props);
    ProjectStore.setInitialState(this.props.projects);
    MembershipStore.setInitialState(this.props.memberships);
    ProjectUsersStore.setInitialState(this.props.users);
    this.state = {
      projects: ProjectStore.getState().projects
    }
    this._filterProjects = this._filterProjects.bind(this);
    this._changeProjects = this._changeProjects.bind(this);
  }

  componentDidMount() {
    FilterStore.listen(this._filterProjects);
    ProjectStore.listen(this._changeProjects);
  }

  componentWillUnmount() {
    FilterStore.unlisten(this._filterProjects);
    ProjectStore.unlisten(this._changeProjects);
  }

  _filterProjects(store) {
    let projectsToView = ProjectStore.getState().projects;
    if(store.projectIds.length !== 0) {
      projectsToView = projectsToView.filter(project => store.projectIds.indexOf(project.id) > -1);
    }
    if(store.userIds.length !== 0) {
      let memberships = MembershipStore.getState().memberships;
      let userProjectsIds = memberships.filter(membership => {
        return store.userIds.indexOf(membership.user_id) > -1;
      }).map(membership => membership.project_id);
      projectsToView = projectsToView.filter(project => userProjectsIds.indexOf(project.id) > -1);
    }
    this.setState({ projects: projectsToView });
  }

  _changeProjects(store) {
    this.setState({ projects: store.projects });
  }

  render() {
    const projects = this.state.projects.map(project => <Project key={project.id} project={project} />);
    return(
      <div>
        <ProjectFilters />
        <div id="projects-users">
          <div className='new-project'>
            <a className='btn btn-primary new-project-add' href={Routes.new_project_path()}>
              <span className='glyphicon glyphicon-plus'></span>
              New Project
            </a>
          </div>
          {projects}
        </div>
        <EditMembershipModal />
      </div>
    );
  }
}

Projects.propTypes = {
  projects: PropTypes.array.isRequired,
  users: PropTypes.array.isRequired,
  memberships: PropTypes.array.isRequired
};
