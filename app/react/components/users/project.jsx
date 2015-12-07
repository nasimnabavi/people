import React, {PropTypes} from 'react';
import MembershipStore from '../../stores/MembershipStore';

export default class Project extends React.Component {
  render() {
    const {user, project} = this.props;
    const membership = MembershipStore.getMembershipForUserInProject(user.id, project.id);
    let showNonBillableSign = false;
    let projectPotential = false;
    if(user.primary_roles[0].technical) {
      if(project.potential) {
        projectPotential = true;
      }
      if(!membership.billable && membership.project_internal == false) {
        showNonBillableSign = true;
      }
    }

    return(
      <div>
          <div className="inline project">
              { projectPotential ? <i className="glyphicon glyphicon-asterisk potential" /> : null }
              { showNonBillableSign ? <i className="glyphicon glyphicon-exclamation-sign notbillable" /> : null }
              <a href={Routes.project_path(project.id)}>{project.name}</a>
          </div>
      </div>
    );
  }
}

Project.propTypes = {
  project: PropTypes.object.isRequired,
  user: PropTypes.object.isRequired
};
