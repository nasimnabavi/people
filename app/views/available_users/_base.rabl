attributes :id, :name, :email, :admin_role, :employment, :phone, :location,
  :contract_type, :archived, :abilities, :next_memberships,
  :current_memberships, :booked_memberships, :available_since

node(:info) { |user| user.info }
node(:notes) { |user| user.user_notes.present? ? simple_format(user.user_notes) : ''  }
node(:role) { |user| user.primary_role }

child(:roles) do
  extends 'roles/base'
end
