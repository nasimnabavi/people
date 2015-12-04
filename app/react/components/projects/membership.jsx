import React, {PropTypes} from 'react';
import ProjectUsersStore from '../../stores/ProjectUsersStore';
import SelectedMembershipActions from '../../actions/SelectedMembershipActions';
import MembershipActions from '../../actions/MembershipActions';
import FilterStore from '../../stores/FilterStore';
import ProjectStore from '../../stores/ProjectStore';
import Moment from 'moment';

export default class Membership extends React.Component {
  constructor(props) {
    super(props);
    this.showEditMembershipModal = this.showEditMembershipModal.bind(this);
    this.archiveMembership = this.archiveMembership.bind(this);
    this._showNonBillableSign = this._showNonBillableSign.bind(this);
  }

  showEditMembershipModal(e) {
    e.preventDefault();
    SelectedMembershipActions.editMembership(this.props.membership);
  }

  archiveMembership(e) {
    e.preventDefault();
    const params = {
      id: this.props.membership.id,
      ends_at: gon.currentTime
    };
    MembershipActions.update(params);
  }

  _showNonBillableSign() {
    const highlightNonBillable = FilterStore.getState().highlightNotBillable;
    let result = false;
    if(highlightNonBillable) {
      const user = ProjectUsersStore.getUser(this.props.membership.user_id);
      const userPrimaryRole = user.primary_roles[0]
      if(this.props.membership.user_id == 51 && this.props.membership.project_id == 1) {
        debugger;
      }
      result = this.props.membership.role_id == userPrimaryRole.id && userPrimaryRole.billable && !this.props.membership.billable;
    }
    return result;
  }

  render() {
    const user = ProjectUsersStore.getUser(this.props.membership.user_id);
    const userName = `${user.last_name} ${user.first_name}`;
    const showNonBillableSign = this._showNonBillableSign();

    let toDate = null
    if(this.props.membership.ends_at) {
      let endsAt = this.props.membership.ends_at;
      toDate = ` ${Moment(endsAt).format("DD.MM")}`;
    }

    let fromDateSection = null;
    if(Moment(this.props.membership.starts_at) > Moment()) {
      let fromDate = ` ${Moment(this.props.membership.starts_at).format("DD.MM")}`;
      fromDateSection = (<span className="label label-default time-from">
        From
        <time>{fromDate}</time>
      </span>);
    }

    return(
      <div className="membership">
        <div className="member-photo">
          <img className="img-circle" src={user.gravatar.gravatar.circle.url} />
        </div>
        <div className="member-name"><a href={Routes.user_path(user.id)}>{userName}</a>
          <span className="icons">
            { showNonBillableSign ? <span className="icon not-billable glyphicon glyphicon-exclamation-sign"></span> : null }
            <a className="edit" onClick={this.showEditMembershipModal}>
              <i className="fa fa-pencil-square-o"></i>
            </a>
            <span className="remove" onClick={this.archiveMembership}>×</span>
          </span>
        </div>
        <div className="member-details">
          { toDate ?
          <span className="label label-default time-to">
            To
            <time>{toDate}</time>
          </span> : null }
          {fromDateSection}
        </div>
      </div>
    );
  }
}

Membership.propTypes = {
  membership: PropTypes.object.isRequired
};
