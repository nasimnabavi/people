class SchedulingController < ApplicationController
  before_filter :authenticate!, only: [:not_scheduled]

  expose(:users) do
    ActiveModel::ArraySerializer.new(
      ScheduledUsersRepository.new.technical,
      each_serializer: UserSchedulingSerializer
    ).as_json
  end
  expose(:roles) do
    ActiveModel::ArraySerializer.new(
      RolesRepository.new.all_technical,
      each_serializer: RoleSerializer
    ).as_json
  end
  expose(:abilities) do
    ActiveModel::ArraySerializer.new(
      AbilitiesRepository.new.all,
      each_serializer: AbilitySerializer
    ).as_json
  end

  expose(:stats) do
    stats = {
      all: repository.all.count,
      juniors_and_interns: repository.scheduled_juniors_and_interns.count,
      to_rotate: repository.to_rotate.count,
      in_internals: repository.in_internals.count,
      with_rotations_in_progress: repository.with_rotations_in_progress.count,
      in_commercial_projects_with_due_date: repository.in_commercial_projects_with_due_date.count,
      booked: repository.booked.count,
      unavailable: repository.unavailable.count,
    }
    stats.merge!(not_scheduled: repository.not_scheduled.count) if current_user.admin?
    stats
  end

  expose(:columns) do
    Scheduling::ColumnSetsBuilder.new.call[action_name]
  end

  def all
    self.users = serialized_users(repository.all)
    render :index
  end

  def juniors_and_interns
    self.users = serialized_users_sorted(repository.scheduled_juniors_and_interns)
    render :index
  end

  def to_rotate
    self.users = serialized_users(repository.to_rotate)
    render :index
  end

  def in_internals
    self.users = serialized_users_sorted(repository.in_internals)
    render :index
  end

  def with_rotations_in_progress
    self.users = serialized_users_sorted(repository.with_rotations_in_progress)
    render :index
  end

  def in_commercial_projects_with_due_date
    self.users = serialized_users(repository.in_commercial_projects_with_due_date)
    render :index
  end

  def booked
    self.users = serialized_users_sorted(repository.booked)
    render :index
  end

  def unavailable
    self.users = serialized_users_sorted(repository.unavailable)
    render :index
  end

  def not_scheduled
    self.users = serialized_users(repository.not_scheduled)
    render :index
  end

  private

  def serialized_users(users)
    ActiveModel::ArraySerializer.new(
      users,
      each_serializer: UserSchedulingSerializer
    ).as_json
  end

  def serialized_users_sorted(users)
    ActiveModel::ArraySerializer.new(
      sort_by_current_membership_start_date(users),
      each_serializer: UserSchedulingSerializer
    ).as_json
  end

  def repository
     @repository ||= ScheduledUsersRepository.new
  end

  def sort_by_current_membership_start_date(collection)
    return collection if collection.size < 2
    collection.sort do |node_a, node_b|
      a = Date.today
      a = node_a.longest_current_membership.starts_at unless node_a.longest_current_membership.nil?
      b = Date.today
      b = node_b.longest_current_membership.starts_at unless node_b.longest_current_membership.nil?

      a.to_time.to_i <=> b.to_time.to_i
    end
  end

  def authenticate!
    redirect_to scheduling_index_path unless current_user.admin?
  end
end
