import React from 'react';
import Select from 'react-select';
import UserActions from '../../actions/UserActions';

class AddUserToTeam extends React.Component {
  static get propTypes() {
    return {
      team: React.PropTypes.object.isRequired,
      users: React.PropTypes.array.isRequired
    };
  }

  constructor(props) {
    super(props);
    this.selectedUser = this.selectedUser.bind(this);
  }

  usersRows() {
    let items = [];
    this.props.users.forEach(user => {
      items.push(
        <option key={user.name} value={user.id}>{user.name}</option>
      )
    });
    return items;
  }

  usersNotInThisTeam() {
    return this.props.users.filter(user => {
      return user.team_ids === null || user.team_ids.indexOf(this.props.team.id) === -1;
    });
  }

  selectedUser(userId) {
    UserActions.addToTeam({ userId: userId, teamId: this.props.team.id});
  }

  failedToPersistUser() {
    Messenger().error('Failed to add user to team');
  }

  render() {
    let options = this.usersNotInThisTeam().map(user => {
      return { label: user.name, value: user.id };
    });
    return (
      <footer>
        <Select
            name="form-field-name"
            options={options}
            onChange={this.selectedUser}
        />
      </footer>
    );
  }
}

export default AddUserToTeam;
