import React, {PropTypes} from 'react';
import Membership from './membership';
import NotesModal from './notes-modal';

export default class User extends React.Component {
  static get propTypes() {
    return {
      user: React.PropTypes.object.isRequired
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

    return(
      <tr>
        <td>
          <div className="avatar">
          </div>
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
        <td>
          <div className="next_projects-region">{next_memberships}</div>
        </td>
        <td>
          <div className="booked_projects-region">{booked_memberships}</div>
        </td>
        <td className="user-notes">
          {notes_modal}
        </td>
      </tr>
    );
  }
}
