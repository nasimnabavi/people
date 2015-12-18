import ProjectUsersStore from '../stores/ProjectUsersStore';

export default class MembershipSource {
  static create(params) {
    const { userId, projectId } = params;
    const roleId = ProjectUsersStore.getUser(userId).primary_roles[0].id;
    return $.ajax({
      url: Routes.memberships_path(),
      method: 'POST',
      dataType: 'json',
      data: {
        membership: {
          user_id: userId,
          project_id: projectId,
          billable: true,
          starts_at: new Date(),
          role_id: roleId
        }
      }
    });
  }

  static update(params) {
    return $.ajax({
      url: Routes.membership_path(params.id),
      method: 'PUT',
      dataType: 'json',
      data: {
        membership: params
      }
    });
  }
}
