import React, {PropTypes} from 'react';
import SchedulingUserStore from '../../stores/SchedulingUserStore'
import RoleStore from '../../stores/RoleStore'
import AbilityStore from '../../stores/AbilityStore'


export default class Scheduling extends React.Component {
  static get propTypes() {
    return {
      users: React.PropTypes.array.isRequired,
      roles: React.PropTypes.array.isRequired,
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
  }

  render() {
    return(
      <div>
        <Filters />
        <table className="table table-striped table-hover scheduled-users">
          <thead>
            <th>
              <p>User</p>
            </th>
            <th>
              <p>Role</p></th>
            <th>Current project</th>
            <th>Next Projects</th>
            <th>Booked</th>
            <th>Notes</th>
          </thead>
          <tbody>
          </tbody>
        </table>
      </div>
    );
  }
}
