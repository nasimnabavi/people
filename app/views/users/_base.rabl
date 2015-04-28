cache ["base", root_object, 1.day]

attributes :id, :name, :email, :admin, :employment, :phone,
  :location_id, :contract_type, :archived, :abilities, :info,
  :months_in_current_project

node(:role) { |user| user.primary_role }
node(:role_id) { |user| user.primary_role.try(:id) }

child(:roles) do
  extends 'roles/base'
end
