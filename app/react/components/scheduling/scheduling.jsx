import React, {PropTypes} from 'react';
import SchedulingUserStore from '../../stores/SchedulingUserStore'
import RoleStore from '../../stores/RoleStore'
import AbilityStore from '../../stores/AbilityStore'
import SchedulingFilterStore from '../../stores/SchedulingFilterStore'
import User from './user';
import Filters from './filters';
import FilteringService from '../../services/scheduling/FilteringService';

export default class Scheduling extends React.Component {
  static get propTypes() {
    return {
      users: React.PropTypes.array.isRequired,
      roles: React.PropTypes.array.isRequired,
      stats: React.PropTypes.object.isRequired,
      abilities: React.PropTypes.array.isRequired
    };
  }

  constructor(props) {
    super(props);
    SchedulingUserStore.setInitialState(this.props.users);
    RoleStore.setInitialState(this.props.roles);
    AbilityStore.setInitialState(this.props.abilities);
    this.state = {
      users: SchedulingUserStore.getState().users
    }
    this._filterUsers = this._filterUsers.bind(this);
    this._changeUsers = this._changeUsers.bind(this);
  }

  componentDidMount() {
    SchedulingFilterStore.listen(this._filterUsers);
    SchedulingUserStore.listen(this._changeUsers);
  }

  componentWillUnmount() {
    SchedulingFilterStore.unlisten(this._filterUsers);
    SchedulingUserStore.unlisten(this._changeUsers);
  }

  _filterUsers(store) {
    let usersToView = SchedulingUserStore.getState().users;
    usersToView = FilteringService.filter(usersToView, store);
    this.setState({ users: usersToView });
  }

  _changeUsers(store) {
    this.setState({ users: store.users });
  }

  render() {
    const users = this.state.users.map(user => <User key={user.id} user={user} />);
    return(
      <div>
        <Filters showHidden={this.props.admin} stats={this.props.stats} />
        <table className="table table-striped table-hover scheduled-users">
          <thead>
            <tr>
              <th></th>
              <th>
                <p>User</p>
              </th>
              <th>
                <p>Role</p>
              </th>
              <th>Current project</th>
              <th>Next Projects</th>
              <th>Booked</th>
              <th>Notes</th>
            </tr>
          </thead>
          <tbody>
            {users}
          </tbody>
        </table>
      </div>
    );
  }
}
