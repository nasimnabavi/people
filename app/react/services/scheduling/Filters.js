export default class Filters {
  static selectUsers(users, store) {
    return users.filter(user => store.userIds.indexOf(user.id) > -1);
  }

  static selectRoles(users, store) {
    return users
      .filter(user => store.roleIds.indexOf(user.primary_role.id) > -1);
  }

  static selectAbilities(users, store) {
    return users.filter(user => {
      let filteredUserAbilities = user
        .ability_ids
        .filter(id => store.abilityIds.indexOf(id) > -1);
      return filteredUserAbilities.length > 0;
    });
  }
}
