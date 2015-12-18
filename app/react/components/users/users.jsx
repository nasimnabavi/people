import React, {PropTypes} from 'react';
import UserStore from '../../stores/UserStore';
import ProjectStore from '../../stores/ProjectStore';
import MembershipStore from '../../stores/MembershipStore';
import RoleStore from '../../stores/RoleStore';
import UserFiltersStore from '../../stores/UserFiltersStore';
import Filters from './filters';
import UsersTableHeader from './users-table-header';
import User from './user';

export default class Users extends React.Component {
  constructor(props) {
    super(props);
    UserStore.setInitialState(this.props.users);
    ProjectStore.setInitialState(this.props.projects);
    MembershipStore.setInitialState(this.props.memberships);
    RoleStore.setInitialState(this.props.roles);
    this.state = {
      users: UserStore.getState().users
    }
    this._usersChanged = this._usersChanged.bind(this);
    this._filtersChanged = this._filtersChanged.bind(this);
  }

  componentDidMount() {
    UserStore.listen(this._usersChanged);
    UserFiltersStore.listen(this._filtersChanged);
  }

  componentWillUnmount() {
    UserStore.unlisten(this._usersChanged);
    UserFiltersStore.unlisten(this._filtersChanged);
  }

  _usersChanged(store) {
    this.setState({ users: store.users });
  }

  _filtersChanged(store) {
    debugger;
    let users = UserStore.getState().users;
    if(store.userIds.length > 0) {
      users = users.filter(user => store.userIds.indexOf(user.id) > -1);
    }
    if(store.roleIds.length > 0) {
      users = users.filter(user => user.primary_roles[0] && store.roleIds.indexOf(user.primary_roles[0].id) > -1);
    }
    if(store.actualProjectIds.length > 0) {
      users = users.filter(user => {
        const actualFilteredProjects = ProjectStore.getCurrentProjectsForUser(user.id)
          .filter(project => store.actualProjectIds.indexOf(project.id) > -1);
        return actualFilteredProjects.length > 0;
      });
    }
    if(store.previousProjectIds.length > 0) {
      users = users.filter(user => {
        const previousFilteredProjects = ProjectStore.getPreviousProjectsForUser(user.id)
          .filter(project => store.previousProjectIds.indexOf(project.id) > -1);
        return previousFilteredProjects.length > 0;
      });
    }
    this.setState({ users: users });
  }

  render() {
    let i = 1;
    const userRows = this.state.users.map(user => <User key={user.id} number={i++} user={user} />);
    return(
      <div>
        <Filters/>
        <table id='users' className='table table-striped table-hover'>
          <UsersTableHeader />
          <tbody>
            {userRows}
          </tbody>
        </table>
      </div>
    );
  }
}

Users.propTypes = {
  users: PropTypes.array.isRequired,
  projects: PropTypes.array.isRequired,
  memberships: PropTypes.array.isRequired,
  roles: PropTypes.array.isRequired
};
