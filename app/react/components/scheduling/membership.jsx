import React, {PropTypes} from 'react';
import moment from 'moment';

export default class Membership extends React.Component {
  static get propTypes() {
    return {
      membership: React.PropTypes.object.isRequired
    };
  }

  constructor(props) {
    super(props);
  }

  render() {
    const membership = this.props.membership;

    const starts_at = moment(membership.starts_at).format('YYYY-MM-DD');
    var starts_at_field;
    if(membership.starts_at) {
      starts_at_field = (
        <span>
          From <span className="time">{starts_at}</span>
        </span>
      );
    }

    const ends_at = moment(membership.ends_at).format('YYYY-MM-DD');
    var ends_at_field;
    if(membership.ends_at) {
      ends_at_field = (
        <span>
          Until <span className="time">{ends_at}</span>
        </span>
      );
    }

    var potential_field;
    if(membership.potential) {
      potential_field = (
        <div className="project-label">potential</div>
      );
    }

    var internal_field;
    if(membership.internal) {
      internal_field = (
        <div className="project-label">internal</div>
      );
    }

    var non_billable_field;
    if(!membership.billable) {
      non_billable_field = (
        <div className="project-label">non-billable</div>
      );
    }

    return(
      <div className="inline project">
        <span className="project-name">
          <a href={"/projects/" + membership.project_id}>{membership.name}</a>
        </span>
        <span className="project-dates">
          {starts_at_field} {ends_at_field}
        </span>
        <div className="project-labels">
          {potential_field}
          {internal_field}
          {non_billable_field}
        </div>
      </div>
    );
  }
}
