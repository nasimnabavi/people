export default class Sorting {
  static sortUsersAlphabetically(users){
    return _.sortBy(users, (user) => {
      return user.name;
    });
  }

  static sortByTimeInProject(users){
    return _.sortBy(users, (user) => {
      const time_spans = _.map(user.current_memberships, (membership) =>
        new Date(membership.starts_at).getTime()
      );
      return _.max(time_spans);
    });
  }
}
