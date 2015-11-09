import React from 'react';
import TeamUser from './team-user';
import Team from './team';
import { Modal, Button } from 'react-bootstrap';

require('react-select/dist/react-select.css');

class Teams extends React.Component {
  static get propTypes() {
    return {
      token: React.PropTypes.string.isRequired,
      users: React.PropTypes.array.isRequired,
      teams: React.PropTypes.array.isRequired,
      roles: React.PropTypes.array.isRequired
    };
  }

  constructor(props) {
    super(props);
    this.state = {
      display: false,
      teams: this.props.teams,
      users: this.props.users,
      showEditTeamModal: false,
      showNoTeamUsers: false
    };
    this.onNewTeamButtonClick = this.onNewTeamButtonClick.bind(this);
    this.closeNewTeamRow = this.closeNewTeamRow.bind(this);
    this.addTeam = this.addTeam.bind(this);
    this.handleTeamChangeName = this.handleTeamChangeName.bind(this);
    this.addedTeam = this.addedTeam.bind(this);
    this.editTeamCallback = this.editTeamCallback.bind(this);
    this.updateTeam = this.updateTeam.bind(this);
    this.removeTeam = this.removeTeam.bind(this);
    this.teamRemoved = this.teamRemoved.bind(this);
    this.teamEdited = this.teamEdited.bind(this);
    this.failedToEditTeam = this.failedToEditTeam.bind(this);
    this.failedToRemoveTeam = this.failedToRemoveTeam.bind(this);
    this.userAddedToTeamCallback = this.userAddedToTeamCallback.bind(this);
    this.teamChangedCallback = this.teamChangedCallback.bind(this);
    this.setMessengerOptions();
  }

  userAddedToTeamCallback(newUser) {
    let userIds = this.state.users.map(user => user.id);
    let userIndex = userIds.indexOf(newUser.id);
    this.state.users[userIndex] = newUser;
    this.setState({ users: this.state.users });
  }

  setMessengerOptions() {
    Messenger.options = {
      extraClasses: 'messenger-fixed messenger-on-top messenger-on-right',
      theme: 'flat',
      messageDefaults: {
        hideAfter: 5
      }
    };
  }

  editTeamCallback(team) {
    this.setState({ showEditTeamModal: true, editedTeam: team });
  }

  onNewTeamButtonClick() {
    this.setState({ display: !this.state.display });
  }

  visibleRoles() {
    return this.props.roles.filter(role => {
      return role.show_in_team === true
    });
  }

  visibleUsers() {
    let visibleRolesIds = this.visibleRoles().map((role) => role.id);
    return this.props.users.filter(user => {
      return user.primary_role_ids.some(roleId => {
        return visibleRolesIds.indexOf(roleId) > -1;
      });
    });
  }

  noTeamUsers() {
    return this.visibleUsers().filter(user => {
      return user.team_ids === null;
    });
  }

  newTeamRow() {
    return (
      <div className="js-new-team-form sm-bottom-margin">
        <div className="form-group">
          <div className="input-group">
            <label className="control-label">
              <abbr title="required"></abbr>
            </label>
            <input className="form-control name" placeholder="Team name..." type="text" onChange={this.handleTeamChangeName}>
            </input>
          </div>
        </div>
        <div className="actions">
          <a className="btn btn-danger btn-sm new-team-close" href="#" onClick={this.closeNewTeamRow}>Close</a>
          <a className="btn btn-default btn-sm new-team-submit" href="#" onClick={this.addTeam}>Add team</a>
        </div>
      </div>
    );
  }

  handleTeamChangeName(e) {
    this.setState({ teamName: e.target.value });
  }

  addTeam(e, smth) {
    $.ajax({
      url: Routes.teams_path(),
      type: "POST",
      dataType: 'json',
      data: {
        team: {
          name: this.state.teamName
        }
      }
    }).done(this.addedTeam).fail(this.failedToAddTeam);
  }

  updateTeam() {
    $.ajax({
      url: Routes.team_path(this.state.editedTeam.id),
      type: "PUT",
      dataType: 'json',
      data: {
        team: {
          name: this.state.newTeamName
        }
      }
    }).done(this.teamEdited).fail(this.failedToEditTeam);
  }

  teamEdited(data) {
    let teamIds = this.state.teams.map(team => team.id);
    let editedTeamIndex = teamIds.indexOf(data.id);
    this.state.teams[editedTeamIndex] = data;
    Messenger().success(`Team ${data.name} changed successfully`);
    this.setState({ teams: this.state.teams, editedTeam: null, showEditTeamModal: false, newTeamName: null });
  }

  failedToEditTeam(xhr, status, err) {
    Messenger().error("Failed to edit team");
  }

  removeTeam() {
    $.ajax({
      url: Routes.team_path(this.state.editedTeam.id),
      type: "DELETE",
      dataType: 'json'
    }).done(this.teamRemoved).fail(this.failedToRemoveTeam);
  }

  teamRemoved() {
    let cleanedTeams = this.state.teams.filter(team => {
      return team != this.state.editedTeam;
    });
    Messenger().success(`${this.state.editedTeam.name} team removed.`);
    this.setState({ showEditTeamModal: false, teams: cleanedTeams, editedTeam: null });
  }

  failedToRemoveTeam() {
    Messenger().error(`Team could not be removed`);
    this.setState({ showEditTeamModal: false, editedTeam: null });
  }

  addedTeam(data, textStatus, jqXHR) {
    this.setState({ display: false });
    this.state.teams.push(data);
    this.setState({ teams: this.state.teams });
    Messenger().success(`${data.name} has been created`);
  }

  failedToAddTeam(xhr, status, err) {
    let errors = JSON.parse(xhr.responseText).errors
    Messenger().error("Name of this team is already taken");
  }

  closeNewTeamRow() {
    this.setState({ display: false });
  }

  teamChangedCallback(newTeam) {
    let oldTeam = this.state.teams.filter(team => team.id === newTeam.id)[0];
    let teamIndex = this.state.teams.indexOf(oldTeam);
    this.state.teams[teamIndex] = newTeam;
    this.setState({teams: this.state.teams});
  }

  render() {
    let closeModal = () => this.setState({ showEditTeamModal: false, editedTeam: null });
    let toggleNoTeamUserRows = () => this.setState({ showNoTeamUsers: !this.state.showNoTeamUsers });
    let noTeamUsersRows = [];
    this.noTeamUsers().forEach(user => {
      noTeamUsersRows.push(
        <TeamUser user={user} roles={this.props.roles} teams={this.props.teams}></TeamUser>);
    });
    let teamRows = [];
    let updateNewTeamName = (e) => this.setState({ newTeamName: e.target.value });
    this.state.teams.forEach(team => {
      let teamUsers = this.props.users.filter(user => user.team_ids != null && user.team_ids.indexOf(team.id) > -1);
      teamRows.push(
        <li className="team-box-flex">
          <Team
            team={team}
            users={this.props.users}
            teamUsers={teamUsers}
            roles={this.props.roles}
            showEditModalCallback={this.editTeamCallback}
            userAddedCallback={this.userAddedToTeamCallback}
            teamChangedCallback={this.teamChangedCallback}></Team>
        </li>
      );
    });
    return (
      <div>
        <div className="row">
          <div className="col-md-12" id="buttons-region">
            <div className="btn btn-success new-team-add xs-bottom-margin" onClick={this.onNewTeamButtonClick}>
              <div className="glyphicon glyphicon-plus pull-left"></div>
              <div className="pull-right small">New team</div>
            </div>
            { this.state.display ? this.newTeamRow() : null}
          </div>
        </div>
        <div className="row">
          <div className="col-md-12" id="no-team-region">
            <div className="btn btn-default lg-bottom-margin show-users" onClick={toggleNoTeamUserRows}>
              <div className="glyphicon glyphicon-user pull-left"></div>
              <div className="pull-right small">Show users without team</div>
            </div>
            <div className="col-md-12 lg-bottom-margin row">
              { this.state.showNoTeamUsers ? noTeamUsersRows : null }
            </div>
          </div>
        </div>
        <div className='row'>
          <div id='teams-region'>
            <div className="table table-hover">
              <ul className='teams-list teams-container-flex' id='teams-body'>
                {teamRows}
              </ul>
            </div>
          </div>
        </div>
        <Modal show={this.state.showEditTeamModal} onHide={closeModal}>
          <Modal.Header closeButton>
            <Modal.Title>Edit team</Modal.Title>
          </Modal.Header>
          <Modal.Body>
            <h4>New name:</h4>
            <input type="text" onChange={updateNewTeamName}></input>
          </Modal.Body>
          <Modal.Footer>
            <Button bsStyle="danger" onClick={this.removeTeam}>Remove team</Button>
            <Button onClick={closeModal}>Close</Button>
            <Button bsStyle="primary" onClick={this.updateTeam}>Save</Button>
          </Modal.Footer>
        </Modal>
    </div>
    );
  }
}

export default Teams;
