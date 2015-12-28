import React, {PropTypes} from 'react';
import ProjectActions from '../../actions/ProjectActions';

export default class ProjectName extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    const {project} = this.props;
    const avatarStyles = {
      backgroundColor: project.color
    };
    const otherStyles = {
      color: "red",
      display: "none"
    };

    const toggleArchiveProject = () => {
      const params = {
        id: project.id,
        archived: !project.archived
      };
      ProjectActions.update(params);
    };

    let archiveIcon = null;

    if(project.archived) {
      archiveIcon = (
        <a className="info unarchive" data-toggle="tooltip" title="fsadasds"
          data-original-title="Unarchive Project" onClick={toggleArchiveProject}>
          <span className="glyphicon glyphicon-folder-open"></span>
        </a>
      );
    } else {
      archiveIcon = (
        <a className="archive info" data-toggle="tooltip" title="dasdasdsa"
          data-original-title="Archive Project" onClick={toggleArchiveProject}>
          <span className="glyphicon glyphicon-folder-close"></span>
        </a>
      );
    }

    return(
      <div className="col-md-3">
        <div className="project-name">
          <div className="project-avatar" style={avatarStyles}>
            {project.initials}
          </div>
          <div className="actual-name">
            <a href={Routes.project_path(project.id)}>{project.name}</a>
            <span className="action">
              {archiveIcon}
            </span>
          </div>
        </div>
        <div className="btn-primary glyphicon glyphicon-list js-open-project-notes show-notes"
          onClick={this.props.toggleNotesCallback}></div>
        <a href={"/projects/" + this.props.project.id + "/edit"}>
          <div className="btn-primary glyphicon glyphicon-pencil show-notes"></div>
        </a>
      </div>
    );
  }
}

ProjectName.propTypes = {
  project: PropTypes.object.isRequired,
  toggleNotesCallback: PropTypes.func.isRequired
};
