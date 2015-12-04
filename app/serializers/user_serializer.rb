class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :gravatar, :primary_roles
end
