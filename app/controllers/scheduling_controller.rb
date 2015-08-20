class SchedulingController < ApplicationController
  include ContextFreeRepos

  before_filter :authenticate_admin!

  expose(:juniors_and_interns) do
    ScheduledUserDecorator.decorate_collection(scheduled_users_repository.juniors_and_interns,
      context: { category: 'juniors-interns' })
  end
  expose(:users_to_rotate) do
    ScheduledUserDecorator.decorate_collection(scheduled_users_repository.to_rotate,
      context: { category: 'to-rotate' })
  end
  expose(:users_in_internals) do
    ScheduledUserDecorator.decorate_collection(scheduled_users_repository.in_internals,
      context: { category: 'internals' })
  end
  expose(:users_with_rotations_in_progress) do
    ScheduledUserDecorator.decorate_collection(
      scheduled_users_repository.with_rotations_in_progress,
      context: { category: 'in-progress' })
  end
  expose(:users_in_commercial_projects_with_due_date) do
    ScheduledUserDecorator.decorate_collection(
      scheduled_users_repository.in_commercial_projects_with_due_date,
      context: { category: 'in-commercial-with-due-date' })
  end
  expose(:booked_users) do
    ScheduledUserDecorator.decorate_collection(
      scheduled_users_repository.booked, context: { category: 'booked' })
  end
  expose(:unavailable_users) do
    ScheduledUserDecorator.decorate_collection(
      scheduled_users_repository.unavailable, context: { category: 'unavailable' })
  end
  expose(:roles) { roles_repository.all }
  expose(:abilities) { abilities_repository.all }

  def index
    set_users_in_gon
    gon.roles = roles
    gon.abilities = abilities
    gon.columns_per_category = Scheduling::ColumnSetsBuilder.new.call
  end

  private

  def set_users_in_gon
    gon.juniors_and_interns = Rabl.render(juniors_and_interns, 'scheduling/index',
      view_path: 'app/views', format: :hash, locals: { cache_key: 'juniors_and_interns' })
    gon.users_to_rotate = Rabl.render(users_to_rotate, 'scheduling/index',
      view_path: 'app/views', format: :hash, locals: { cache_key: 'to-rotate' })
    gon.users_in_internals = Rabl.render(users_in_internals, 'scheduling/index',
      view_path: 'app/views', format: :hash, locals: { cache_key: 'internals' })
    gon.users_with_rotations_in_progress = Rabl.render(users_with_rotations_in_progress,
      'scheduling/index', view_path: 'app/views', format: :hash,
      locals: { cache_key: 'in-progress' })
    gon.users_in_commercial_projects_with_due_date =
      Rabl.render(users_in_commercial_projects_with_due_date, 'scheduling/index',
        view_path: 'app/views', format: :hash,
        locals: { cache_key: 'in-commercial-with-due-date' })
    gon.booked_users = Rabl.render(booked_users, 'scheduling/index',
      view_path: 'app/views', format: :hash, locals: { cache_key: 'booked' })
    gon.unavailable_users = Rabl.render(unavailable_users, 'scheduling/index',
      view_path: 'app/views', format: :hash, locals: { cache_key: 'unavailable' })
    gon.not_scheduled_users = Rabl.render(find_missing_users, 'scheduling/index',
      view_path: 'app/views', format: :hash, locals: { cache_key: 'missing' })
  end

  def find_missing_users
    ids = [gon.juniors_and_interns, gon.users_to_rotate, gon.users_in_internals,
      gon.users_with_rotations_in_progress, gon.users_in_commercial_projects_with_due_date,
      gon.booked_users, gon.unavailable_users]
      .flat_map { |category| category.map { |user| user[:id] } }
    ScheduledUserDecorator.decorate_collection(
      Scheduling::MissingUsers.new(ids).call, context: { category: 'not-scheduled' })
  end
end
