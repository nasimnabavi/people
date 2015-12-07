import alt from '../alt';

import ProjectActions from '../actions/ProjectActions';
import ProjectSource from '../sources/ProjectSource';
import MembershipStore from './MembershipStore';
import Moment from 'moment';

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

  static getCurrentProjectsForUser(userId) {
    const userCurrentMembershipsProjectIds = MembershipStore.getState().memberships
      .filter(membership => membership.user_id == userId)
      .filter(membership => Moment(membership.starts_at) < Moment())
      .filter(membership => (membership.ends_at == null || Moment(membership.ends_at) > Moment()))
      .map(membership => membership.project_id);
    return this.state.projects.filter(project => userCurrentMembershipsProjectIds.indexOf(project.id) > -1);
  }

  static getNextProjectsForUser(userId) {
    const userNextMembershipsProjectIds = MembershipStore.getState().memberships
      .filter(membership => membership.user_id == userId)
      .filter(membership => Moment(membership.starts_at) > Moment())
      .filter(membership => !membership.booked)
      .map(membership => membership.project_id);
    return this.state.projects.filter(project => userNextMembershipsProjectIds.indexOf(project.id) > -1);
  }

  static getBookedProjectsForUser(userId) {
    const userBookedMembershipsProjectIds = MembershipStore.getState().memberships
      .filter(membership => membership.user_id == userId)
      .filter(membership => membership.booked)
      .map(membership => membership.project_id);
    return this.state.projects.filter(project => userBookedMembershipsProjectIds.indexOf(project.id) > -1);
  }

  static getPreviousProjectsForUser(userId) {
    const userPreviousMembershipsProjectIds = MembershipStore.getState().memberships
      .filter(membership => membership.user_id == userId)
      .filter(membership => membership.ends_at != null && Moment(membership.ends_at) < Moment())
      .map(membership => membership.project_id);
    return this.state.projects.filter(project => userPreviousMembershipsProjectIds.indexOf(project.id) > -1);
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
