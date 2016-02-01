import React, {PropTypes} from 'react';
import Membership from './membership';
import NotesModal from './notes-modal';

export default class User extends React.Component {
  static get propTypes() {
    return {
      user: React.PropTypes.object.isRequired,
      currentTab: React.PropTypes.string
    };
  }

  constructor(props) {
    super(props);
    this.state = {
      user: props.user
    };
  }

  render() {
    const user = this.state.user;
    var current_memberships;
    if(user.current_memberships.length !== 0) {
      current_memberships = user.current_memberships.map(membership =>
        <Membership key={membership.id} membership={membership} />
      );
    } else {
      current_memberships = <span>No current projects.</span>;
    }

    var next_memberships;
    if(user.next_memberships.length !== 0) {
      next_memberships = user.next_memberships.map(membership =>
        <Membership key={membership.id} membership={membership} />
      );
    } else {
      next_memberships = <span>No next projects.</span>;
    }

    var booked_memberships;
    if(user.booked_memberships.length !== 0) {
      booked_memberships = user.booked_memberships.map(membership =>
        <Membership key={membership.id} membership={membership} />
      );
    } else {
      booked_memberships = <span>No booked projects.</span>;
    }

    var notes_modal;
    if(user.user_notes) {
      notes_modal = <NotesModal notes={user.user_notes}/>;
    }

    if(this.props.currentTab == 'to_rotate') {
      var rowClass = user.rotation_class
    }

    if(this.props.columns.indexOf('Next project') > -1) {
      var next_memberships_column = (
        <td>
          <div className="next_projects-region">{next_memberships}</div>
        </td>
      )
    }

    if(this.props.columns.indexOf('Booked') > -1) {
      var booked_memberships_column = (
        <td>
          <div className="booked_projects-region">{booked_memberships}</div>
        </td>
      )
    }

    return(
      <tr className={rowClass}>
        <td>
          <img className="img-circle" src={user.gravatar.gravatar.circle.url} />
        </td>
        <td>
          <div className="profile">
            <span className="name">
              <a href={"/users/" + user.id}>{user.name}</a>
            </span>
          </div>
        </td>
        <td>
          <span className="role">{user.primary_role.name}</span>
        </td>
        <td>
          <div className="projects-region">{current_memberships}</div>
        </td>
        {next_memberships_column}
        {booked_memberships_column}
        <td className="user-notes">
          {notes_modal}
        </td>
      </tr>
    );
  }
}
