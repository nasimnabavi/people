import React from 'react';
import TeamUser from './team-user';
import AddUserToTeam from './add-user-to-team';

class Team extends React.Component {
  static get propTypes() {
    return {
      team: React.PropTypes.object.isRequired,
      users: React.PropTypes.array.isRequired,
      teamUsers: React.PropTypes.array.isRequired,
      roles: React.PropTypes.array.isRequired,
      showEditModalCallback: React.PropTypes.func.isRequired,
      userAddedCallback: React.PropTypes.func.isRequired,
      teamChangedCallback: React.PropTypes.func.isRequired
    };
  }

  constructor(props) {
    super(props);
    this.state = { display: false, teamUsers: this.props.teamUsers };
    this.showEditModal = this.showEditModal.bind(this);
  }

  nonBillableRows() {
    let items = [];
    this.nonBillableUsers().forEach(user => {
      items.push(
        <li key={user.id}>
          <TeamUser user={user} roles={this.props.roles} viewedInTeam={this.props.team}
            removedFromTeamCallback={this.props.userAddedCallback}
            teamChangedCallback={this.props.teamChangedCallback} />
        </li>
      );
    });
    return items;
  }

  billableRows() {
    let items = [];
    this.billableUsers().forEach(user => {
      items.push(
        <li key={user.id}>
          <TeamUser user={user} roles={this.props.roles} viewedInTeam={this.props.team}
            removedFromTeamCallback={this.props.userAddedCallback}
            teamChangedCallback={this.props.teamChangedCallback} />
        </li>
      );
    });
    return items;
  }

  billableUsers() {
    let billableRolesIds = this.billableRoles().map(role => role.id);

    return this.nonLeaderUsers().filter(user => {
      return user.primary_role_ids.some(elem => billableRolesIds.indexOf(elem) > -1);
    });
  }

  nonBillableUsers() {
    let nonBillableRolesIds = this.nonBillableRoles().map(role => role.id);

    return this.nonLeaderUsers().filter(user => {
      return user.primary_role_ids.some(elem => nonBillableRolesIds.indexOf(elem) > -1);
    });
  }

  billableRoles() {
    return this.props.roles.filter(role => {
      return role.billable === true;
    });
  }

  nonLeaderUsers() {
    return this.props.teamUsers.filter(user => user.id != this.props.team.user_id);
  }

  nonBillableRoles() {
    return this.props.roles.filter(role => {
      return role.billable === false;
    });
  }

  showEditModal(e) {
    e.preventDefault();
    this.props.showEditModalCallback(this.props.team);
  }

  leader() {
    let leaderUser = this.props.users.filter(user => user.id === this.props.team.user_id);
    return leaderUser.length > 0 ? leaderUser[0] : null;
  }

  leaderRow() {
    let leaderUser = this.leader();
    if(leaderUser != null) {
      let styles = { display: 'list-item' }
      return (
        <ul id='leader-region' className="team-members filled">
          <li style={styles}>
            <TeamUser
              user={leaderUser}
              isLeader={true}
              roles={this.props.roles}
              viewedInTeam={this.props.team}
              removedFromTeamCallback={this.props.userAddedCallback}
              teamChangedCallback={this.props.teamChangedCallback}>
            </TeamUser>
          </li>
        </ul>
      );
    } else {
      return (
        <ul id="leader-region" className="team-members empty">
          <li>
            <div className="dummy">
              <div className="dummy-avatar"></div>
              <div className="dummy-member">
                Pick a leader
              </div>
            </div>
          </li>
        </ul>
      );
    }
  }

  render() {
    let addUserToTeamSection = (
      <AddUserToTeam
      users={this.props.users}
      team={this.props.team} />
    );
    let editButton = (
      <div className="admin-section" onClick={this.showEditModal}>
        <span className="js-edit-team glyphicon glyphicon-pencil"/>
      </div>
    );
    return (
      <article className='team'>
        <header>
          <div className='team-avatar' styles={this.props.team.color}>
            {this.props.team.initials}
          </div>
          <h3 className='team-name'>{this.props.team.name}</h3>
          <p className='devs-indicator'>
            <span className='devs'>{this.billableUsers().length}</span>
            <span className='jnrs'>{this.nonBillableUsers().length}</span>
          </p>
          <div class-name="edit-button">
            { gon.current_user_is_emailed_admin ? editButton : null }
          </div>
        </header>
        <div className="leader-row">
          {this.leaderRow()}
        </div>
        <div id='members-region'>
          <ul className="team-members">
            {this.billableRows()}
            {this.nonBillableRows()}
          </ul>
        </div>
        <div>
          { gon.current_user_is_emailed_admin ? addUserToTeamSection : null }
        </div>
      </article>
    );
  }
}

export default Team;
