import React, {PropTypes} from 'react';
import Project from './project';
import ProjectStore from '../../stores/ProjectStore';
import UserActions from '../../actions/UserActions';

export default class User extends React.Component {
  render() {
    const user = this.props.user;
    const styles = {
      display: "table-row"
    }
    const currentProjectRows = ProjectStore.getCurrentProjectsForUser(user.id).map(project => {
      return <Project key={project.id} project={project} user={user} />
    });

    const nextProjectRows = ProjectStore.getNextProjectsForUser(user.id).map(project => {
      return <Project key={project.id} project={project} user={user} />
    });

    const bookedProjectRows = ProjectStore.getBookedProjectsForUser(user.id).map(project => {
      return <Project key={project.id} project={project} user={user} />
    });

    const toggleAdminForUser = (e) => {
      const userId = user.id;
      UserActions.update({ id: userId, admin: e.target.checked });
    };

    const userPrimaryRoleName = user.primary_roles[0] ? user.primary_roles[0].name : 'No primary role';

    return(
      <tr style={styles}>
        <td>{this.props.number}</td>
        <td className="to_end"></td>
        <td><img src={user.gravatar.gravatar.circle.url} /></td>
        <td>
            <a href={Routes.user_path(user.id)}>{user.last_name + " " + user.first_name}</a>
        </td>
        <td>{userPrimaryRoleName}</td>
        <td>
            <div className="employment-container input-group">
                <p>{user.commitment} h</p>
            </div>
        </td>
        <td>
            <div className="projects-region">
                <div>
                    <div className="project__header">Current:</div>
                    <div className="projects">
                        {currentProjectRows.length > 0 ? currentProjectRows : "No current projects"}
                    </div>
                </div>
            </div>
            <div className="next_projects-region">
                <div>
                    <div className="project__header">Next:</div>
                    <div className="projects">
                        {nextProjectRows.length > 0 ? nextProjectRows : "No next projects"}
                    </div>
                </div>
            </div>
            <div className="booked_projects-region">
                <div>
                    <div className="project__header">Booked:</div>
                    <div className="projects">
                        {bookedProjectRows.length > 0 ? bookedProjectRows : "No booked projects"}
                    </div>
                </div>
            </div>
        </td>
        <td>
            <input className="admin form-control" type="checkbox" checked={user.admin}
              onChange={toggleAdminForUser} />
        </td>
    </tr>
    );
  }
}

User.propTypes = {
  user: PropTypes.object.isRequired,
  number: PropTypes.number.isRequired
};
