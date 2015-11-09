import React from 'react';
import Select from 'react-select';

class AddUserToTeam extends React.Component {
  static get propTypes() {
    return {
      team: React.PropTypes.object.isRequired,
      users: React.PropTypes.array.isRequired,
      userAddedCallback: React.PropTypes.func.isRequired
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
    let user = this.props.users.filter(user => user.id == userId)[0];
    let userIndex = this.props.users.indexOf(user);
    if(user.team_ids === null) {
      user.team_ids = [this.props.team.id];
    } else { user.team_ids.push(this.props.team.id) };
    let userPersisted = () => {
      Messenger().success(`User ${user.name} added to team`);
      this.props.userAddedCallback(user);
    };
    $.ajax({
      url: Routes.user_path(userId),
      type: "PUT",
      dataType: 'json',
      data: {
        user: {
          team_ids: user.team_ids
        }
      }
    }).done(userPersisted).fail(this.failedToPersistUser);
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
