import alt from '../alt';

import ProjectActions from '../actions/ProjectActions';
import ProjectSource from '../sources/ProjectSource';

class ProjectStore {
  constructor() {
    this.bindActions(ProjectActions);
    this.projects = [];
  }

  update(params) {
    const projectUpdated = (data) => {
      let projects = this.projects;
      const projectIds = projects.map(project => project.id);
      const projectIndex = projectIds.indexOf(data.id);
      const oldProject = projects[projectIndex];
      if(oldProject.archived != data.archived) {
        projects.splice(projectIndex, 1);
      } else {
        projects[projectIndex] = data;
      }
      this.setState({ projects: projects });
    };

    const failedToUpdate = () => {
      debugger;
    };
    ProjectSource.update(params).done(projectUpdated).fail(failedToUpdate);
    return false;
  }

  static getNotesForProject(projectId) {
    return this.state.projects.filter(project => project.id == projectId)[0].notes;
  }

  static getProject(projectId) {
    const project = this.state.projects.filter(project => project.id == projectId);
    if(project.length > 0) {
      return project[0];
    }
    return null;
  }

  static setInitialState(projects) {
    this.state.projects = projects;
  }
}

export default alt.createStore(ProjectStore);
