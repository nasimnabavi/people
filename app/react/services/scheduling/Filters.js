export default class Filters {
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
    return users;
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
    return users.filter(
      user => _.some(user.current_memberships, (membership) => {
        return !membership.internal && membership.billable && !membership.ends_at;
      })
    )
  }

  static selectInternals(users) {
    return users.filter(
      user => _.some(user.current_memberships, (membership) => membership.internal)
    )
  }

  static selectInRotation(users) {
    return users.filter(
      user => _.some(user.next_memberships, (membership) => {
        return !membership.internal && membership.billable && !membership.ends_at;
      })
    )
  }

  static selectUnavailable(users) {
    return users.filter(
      user => _.some(user.current_memberships, (membership) => {
        return membership.name === "unavailable";
      })
    )
  }

  static selectNotAvailable(users) {
    return users.filter(
      user => _.some(user.current_memberships, (membership) => {
        return membership.name === "unavailable";
      })
    )
  }
}
