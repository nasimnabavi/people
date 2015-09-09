class MembershipsController < ApplicationController
  include Shared::RespondsController
  include ContextFreeRepos

  respond_to :json, only: [:create, :update]

  expose(:membership, attributes: :membership_params)
  expose_decorated(:memberships) { memberships_repository.all }
  expose_decorated(:projects) { projects_repository.all }
  expose_decorated(:roles) { roles_repository.all_by_name }
  expose_decorated(:users) { current_user.admin? ? users_repository.all_by_name : [current_user] }

  before_filter :authenticate_admin!, only: [:index, :update, :destroy, :create, :edit], unless: -> { membership.user == current_user }
  before_action :set_users_gon, only: [:new, :create]

  def index; end

  def create
    if membership.save
      SendMailJob.new.async.perform_with_user(MembershipMailer, :created, membership, current_user)
      respond_on_success
    else
      respond_on_failure membership.errors
    end
  end

  def update
    old_values = old_values(membership)
    if membership.save
      data = { membership: membership, old_values: old_values }
      SendMailJob.new.async.perform_with_user(MembershipMailer, :updated, data, current_user)
      respond_on_success user_path(membership.user)
    else
      respond_on_failure membership.errors
    end
  end

  def destroy
    if membership.destroy
      respond_on_success request.referer
    else
      respond_on_failure membership.errors
    end
  end

  protected

  def membership_params
    params.require(:membership)
      .permit(:starts_at, :ends_at, :project_id, :user_id, :role_id, :billable, :booked)
  end

  private

  def old_values(membership)
    values = {}
    if membership.starts_at_changed?
      values[:starts_at] = membership.starts_at_was
    end
    if membership.ends_at_changed?
      values[:ends_at] = membership.ends_at_was || 'not specified'
    end
    values
  end

  def set_users_gon
    gon.rabl template: 'app/views/memberships/users', as: 'users'
  end
end
