import ProjectStore from '../../stores/ProjectStore'

export default class Filters {
  static _isUserBooked(user) {
    return user.booked_memberships.length > 0;
  }

  static selectUsers(users, store) {
    return users.filter(user => store.userIds.indexOf(user.id) > -1);
  }

  static selectRoles(users, store) {
    return users.filter(user => store.roleIds.indexOf(user.primary_role.id) > -1);
  }

  static selectAbilities(users, store) {
    return users.filter(user => {
      let filteredUserAbilities = user.ability_ids.filter(id => store.abilityIds.indexOf(id) > -1);
      return filteredUserAbilities.length > 0
    });
  }

  static selectAll(users) {
    return _.filter(users, (user) => {
      return user.current_memberships.length > 0 || user.next_memberships.length > 0
    });
  }

  static selectJuniorsAndInterns(users) {
    return users.filter(
      user => {
        let name = user.primary_role.name.toLowerCase();
        return name.indexOf('junior') > -1 || name.indexOf('intern') > -1;
      }
    )
  }

  static selectToRotate(users) {
    var stores = ProjectStore;
    debugger
    return users.filter(user => {
      if(_isUserBooked(user))
        return false;
      _.some(user.current_memberships, (membership) => {
        return !membership.internal && membership.billable && !membership.ends_at;
      })
    })
  }

  static selectInternals(users) {
    return users.filter(user => {
      if(_isUserBooked(user))
        return false;
      if(_.some(user.current_memberships, (membership) => membership.internal))
        return true;
      if(_.some(user.next_memberships, (membership) => membership.internal))
        return true;
      return false;
    })
  }

  static selectInRotation(users) {
    return users.filter(user => {
      if(_isUserBooked(user))
        return false;
      _.some(user.next_memberships, (membership) => {
        return !membership.internal;
      })
    })
  }

  static showInCommercialProjectsWithDueDate(users) {
    debugger
    return users.filter(user => {
      if(_isUserBooked(user))
        return false;
      _.some(user.next_memberships, (membership) => {
        return !membership.internal && membership.ends_at;
      })
    })
  }

  static showBooked(users) {
    return users.filter(user => _isUserBooked(user))
  }

  static selectUnavailable(users) {
    return users.filter(user => {
      if(_isUserBooked(user))
        return false;
      _.some(user.current_memberships, (membership) => {
        return membership.name === "unavailable";
      })
    })
  }

  static selectNotScheduled(users) {
    return _.filter(users, (user) => {
      return user.current_memberships.length == 0 && user.next_memberships.length == 0
    });
  }
}
