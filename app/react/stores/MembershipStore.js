import alt from '../alt';

import MembershipActions from '../actions/MembershipActions';
import MembershipSource from '../sources/MembershipSource';
import FilterStore from './FilterStore';
import Moment from 'moment';

class MembershipStore {
  constructor() {
    this.bindActions(MembershipActions);
    this.memberships = [];
  }

  create(params) {
    const savedMembership = (data) => {
      let memberships = this.memberships;
      memberships.push(data);
      this.setState({ memberships: memberships });
      this.emitChange();
    };
    const failedToSave = () => {
      console.log("FAILED TO SAVE");
    };
    MembershipSource.create(params).done(savedMembership).fail(failedToSave);
    return false;
  }

  update(params) {
    const updatedMembership = (data) => {
      let memberships = this.memberships;
      const membershipsIds = memberships.map(membership => membership.id);
      const membershipIndex = membershipsIds.indexOf(data.id);
      memberships[membershipIndex] = data;
      Messenger().success("Membership updated!");
      this.emitChange();
    };
    const failedToUpdate = () => {
      console.log("FAILED TO UPDATE");
    };
    MembershipSource.update(params).done(updatedMembership).fail(failedToUpdate);
    return false;
  }

  static billableMemberships(projectId) {
    return this.memberships(projectId)
      .filter(membership => membership.billable == true &&
        (membership.ends_at == null || Moment(membership.ends_at) > Moment()));
  }

  static nonBillableMemberships(projectId) {
    return this.memberships(projectId)
      .filter(membership => membership.billable == false &&
        (membership.ends_at == null || Moment(membership.ends_at) > Moment()));
  }

  static memberships(projectId) {
    const showNext = FilterStore.getState().showNext;
    let memberships = this.state.memberships.filter(membership => membership.project_id == projectId);
    if(!showNext) {
      memberships = memberships.filter(membership => Moment(membership.starts_at) < Moment());
    }
    return memberships;
  }

  static getMembershipForUserInProject(userId, projectId) {
    const membership = this.state.memberships.filter(membership => {
      return membership.user_id == userId && membership.project_id == projectId;
    });
    if(membership.length > 0) {
      return membership[0];
    }
    return null;
  }

  static setInitialState(memberships) {
    this.state.memberships = memberships;
  }
}

export default alt.createStore(MembershipStore);
