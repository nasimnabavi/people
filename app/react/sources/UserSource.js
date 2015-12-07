export default class UserSource {
  static update(params) {
    return $.ajax({
      url: Routes.user_path(params.id),
      type: "PUT",
      dataType: 'json',
      data: {
        user: params
      }
    });
  }
}
