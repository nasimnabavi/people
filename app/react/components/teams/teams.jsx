import React from 'react';
import TeamUser from './team-user';
import Team from './team';
import Modal from 'react-modal';
import TeamActions from '../../actions/TeamActions';
import TeamStore from '../../stores/TeamStore';

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
    TeamStore.setInitialState(this.props.teams);
    this.state = {
      display: false,
      teams: TeamStore.getState().teams,
      users: this.props.users,
      showEditTeamModal: false,
      showNoTeamUsers: false
    };
    this.onNewTeamButtonClick = this.onNewTeamButtonClick.bind(this);
    this.handleTeamChangeName = this.handleTeamChangeName.bind(this);
    this.editTeamCallback = this.editTeamCallback.bind(this);
    this.updateTeam = this.updateTeam.bind(this);
    this.removeTeam = this.removeTeam.bind(this);
    this.teamRemoved = this.teamRemoved.bind(this);
    this.teamEdited = this.teamEdited.bind(this);
    this.failedToEditTeam = this.failedToEditTeam.bind(this);
    this.failedToRemoveTeam = this.failedToRemoveTeam.bind(this);
    this.userAddedToTeamCallback = this.userAddedToTeamCallback.bind(this);
    this.teamChangedCallback = this.teamChangedCallback.bind(this);
    this._onTeamChange = this._onTeamChange.bind(this);
    this.setMessengerOptions();
  }

  componentDidMount() {
    TeamStore.listen(this._onTeamChange);
  }

  componentWillUnmount() {
    TeamStore.unlisten(this._onTeamChange);
  }

  _onTeamChange(store) {
    this.setState({ teams: store.teams, display: false });
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
    const createTeam = () => TeamActions.create(this.state.teamName);
    const closeNewTeamRow = () => this.setState({ display: false });
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
          <a className="btn btn-danger btn-sm new-team-close" href="#" onClick={closeNewTeamRow}>Close</a>
          <a className="btn btn-default btn-sm new-team-submit" href="#" onClick={createTeam}>Add team</a>
        </div>
      </div>
    );
  }

  handleTeamChangeName(e) {
    this.setState({ teamName: e.target.value });
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
        <TeamUser key={user.id} user={user} roles={this.props.roles} teams={this.props.teams}></TeamUser>);
    });
    let teamRows = [];
    let updateNewTeamName = (e) => this.setState({ newTeamName: e.target.value });
    this.state.teams.forEach(team => {
      let teamUsers = this.props.users.filter(user => user.team_ids != null && user.team_ids.indexOf(team.id) > -1);
      teamRows.push(
        <li className="team-box-flex" key={team.id}>
          <Team
            team={team}
            users={this.visibleUsers()}
            teamUsers={teamUsers}
            roles={this.props.roles}
            showEditModalCallback={this.editTeamCallback}
            userAddedCallback={this.userAddedToTeamCallback}
            teamChangedCallback={this.teamChangedCallback}></Team>
        </li>
      );
    });
    let newTeamArea = (
      <div className="row">
        <div className="col-md-12" id="buttons-region">
          <div className="btn btn-success new-team-add xs-bottom-margin" onClick={this.onNewTeamButtonClick}>
            <div className="glyphicon glyphicon-plus pull-left"></div>
            <div className="pull-right small">New team</div>
          </div>
          { this.state.display ? this.newTeamRow() : null}
        </div>
      </div>
    );
    Modal.setAppElement('body');

    return (
      <div className="whole-teams">
        { gon.current_user_is_emailed_admin ? newTeamArea : null }
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
        <Modal
          className="Modal__Bootstrap modal-dialog"
          closeTimeoutMS={150}
          isOpen={this.state.showEditTeamModal}
          onRequestClose={closeModal}>
          <div className="modal-content">
            <div className="modal-header">
              <button type="button" className="close" onClick={closeModal}>
                <span aria-hidden="true">&times;</span>
                <span className="sr-only">Close</span>
              </button>
              <h4 className="modal-title">Edit team</h4>
            </div>
            <div className="modal-body">
              <h4>New name: </h4>
              <input type="text" onChange={updateNewTeamName}></input>
            </div>
            <div className="modal-footer">
              <button type="button" className="btn btn-danger" onClick={this.removeTeam}>Remove</button>
              <button type="button" className="btn btn-default" onClick={closeModal}>Close</button>
              <button type="button" className="btn btn-primary" onClick={this.updateTeam}>Save changes</button>
            </div>
          </div>
        </Modal>
    </div>
  );
  }
}

export default Teams;
