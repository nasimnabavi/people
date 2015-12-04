export default class ProjectSource {
  static update(params) {
    return $.ajax({
      url: Routes.project_path(params.id),
      method: "PUT",
      dataType: "json",
      data: {
        project: params
      }
    });
  }
}
