class NoteSerializer < ActiveModel::Serializer
  attributes :id, :text, :project_id, :user_id, :open, :user_gravatar_url

  def user_gravatar_url
    object.user.gravatar.circle.url
  end
end
