class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :gravatar, :commitment, :admin, :primary_roles
end
