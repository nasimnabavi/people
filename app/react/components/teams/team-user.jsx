import React from 'react';
import { Tooltip, OverlayTrigger } from 'react-bootstrap';

class TeamUser extends React.Component {
  static get propTypes() {
    return {
      user: React.PropTypes.object.isRequired,
      roles: React.PropTypes.array.isRequired,
      viewedInTeam: React.PropTypes.object,
      isLeader: React.PropTypes.bool,
      removedFromTeamCallback: React.PropTypes.func,
      teamChangedCallback: React.PropTypes.func
    };
  }

  constructor(props) {
    super(props);
    this.promoteToLeader = this.promoteToLeader.bind(this);
    this.removeFromTeam = this.removeFromTeam.bind(this);
  }

  userIsAdmin() {
    return this.props.user.isAdmin;
  }

  linkToUserProfile() {
    let link = '/users/' + this.props.user.id;
    return (
      <a href={link}>{ this.props.user.name }</a>
    )
  }

  userImage() {
    if(this.props.user.gravatar === null) {
      return (
        <img className='img-circle' />
      );
    } else {
      return (
        <img className='img-circle' src={this.props.user.gravatar}/>
      );
    }
  }

  leaderStar() {
    if(this.props.isLeader) {
      return (
        <span className="glyphicon glyphicon-star"></span>
      );
    } else { return ''; }
  }

  userRoles() {
    let userRoleIds = this.props.user.primary_role_ids;
    return this.props.roles.filter(role => {
      return _.contains(userRoleIds, role.id);
    });
  }

  labels() {
    let roles = this.userRoles();
    if(roles.length > 0) {
      return roles.map(role => role.name);
    } else { return 'no role'; }
  }

  billableRoles() {
    return this.props.roles.filter(role => {
      return role.billable === true;
    });
  }

  isBillable() {
    let userRoleIds = this.props.user.primary_role_ids;
    return this.billableRoles().filter(role => {
      return _.contains(userRoleIds, role.id);
    }).length > 0;
  }

  labelsRow() {
    if(this.isBillable()) {
      return (
        <div className='label label-default billable'>{this.labels()}</div>
      );
    } else {
      return (
        <div className='label label-default'>{this.labels()}</div>
      );
    }
  }

  actions() {
    if(gon.current_user.admin && this.props.viewedInTeam) {
      const tooltip = (
        <Tooltip id="leader-star">Promote to leader</Tooltip>
      );
      const leaderStarAction = (
        <OverlayTrigger placement="top" overlay={tooltip}>
          <span className='js-promote-leader glyphicon glyphicon-star make-leader'
            onClick={this.promoteToLeader}>
          </span>
        </OverlayTrigger>
      );
      let isNotLeaderOfTeam = () => {
        return !(this.props.viewedInTeam.user_id === this.props.user.id);
      };
      return (
        <div className="actions">
          { isNotLeaderOfTeam() ? leaderStarAction : null }
          <span
            className='js-exclude-member glyphicon glyphicon-remove'
            onClick={this.removeFromTeam}>
          </span>
        </div>
      )
    } else { return null; };
  }

  promoteToLeader() {
    this.props.viewedInTeam.user_id = this.props.user.id;
    let leaderPromoted = () => {
      Messenger().success("New leader promoted!");
      this.props.teamChangedCallback(this.props.viewedInTeam);
    };
    $.ajax({
      url: Routes.team_path(this.props.viewedInTeam.id),
      type: "PUT",
      dataType: 'json',
      data: {
        team: {
          user_id: this.props.user.id
        }
      }
    }).done(leaderPromoted).fail(this.failedToPromoteLeader);
  }

  failedToPromoteLeader() {
    Messenger().error("Failed to promote user to leader");
  }

  removeFromTeam() {
    let user = this.props.user;
    let userTeamIds = user.team_ids;
    userTeamIds.splice(userTeamIds.indexOf(this.props.viewedInTeam.id), 1);
    userTeamIds = userTeamIds.length === 0 ? null : userTeamIds;
    user.team_ids = userTeamIds;
    let removedFromTeam = () => {
      Messenger().success("User removed from team successfully");
      this.props.removedFromTeamCallback(user);
    }
    $.ajax({
      url: Routes.user_path(user.id),
      type: "PUT",
      dataType: 'json',
      data: {
        user: {
          team_ids: userTeamIds
        }
      }
    }).done(removedFromTeam).fail(this.failedToRemoveFromTeam);
  }

  failedToRemoveFromTeam() {
    Messenger().error("Failed to remove from team");
  }

  render() {
    let noTeamStyles = this.props.viewedInTeam ? '' : 'col-md-2';
    return (
      <div className={noTeamStyles}>
        <div className='membership'>
          <div className='member-photo'>
            { this.userImage() }
          </div>
          <div className='member-name'>
            { this.linkToUserProfile() }
            { this.leaderStar() }
          </div>
          <div className='member-details'>
            {this.labelsRow()}
            <div className='label label-info js-number-of-days'></div>
          </div>
        </div>
        {this.actions()}
      </div>
    );
  }
}

export default TeamUser;
