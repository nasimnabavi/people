FactoryGirl.define do
  factory :available_users_hash, class: Hash do
    project
    dev_without_due_date { {
      with_nothing_scheduled: create(:developer_in_project, project: project),
      with_commercial_project_scheduled:
        create(:developer_in_project, :with_project_scheduled,
          project: project,
          scheduled_project: create(:project, :without_due_date, :commercial),
          scheduled_membership_start: 5.days.from_now
        ),
      with_internal_project_scheduled:
        create(:developer_in_project, :with_project_scheduled,
          project: project,
          scheduled_project: create(:project, :without_due_date, :internal),
          scheduled_membership_start: 5.days.from_now
        ),
      booked:
        create(:developer_in_project, :with_project_scheduled,
          project: project,
          scheduled_project: create(:project, :without_due_date),
          scheduled_membership_start: 5.days.from_now,
          booked: true
        )
    } }

    dev_with_due_date { {
      with_nothing_scheduled: create(:developer_in_project,
        project: project,
        membership_due_date: 5.days.from_now
      ),
      with_commercial_project_scheduled:
        create(:developer_in_project, :with_project_scheduled,
          project: project,
          scheduled_project: create(:project, :without_due_date, :commercial),
          scheduled_membership_start: 5.days.from_now,
          membership_due_date: 5.days.from_now
        ),
      with_internal_project_scheduled:
        create(:developer_in_project, :with_project_scheduled,
          project: project,
          scheduled_project: create(:project, :without_due_date, :internal),
          scheduled_membership_start: 5.days.from_now,
          membership_due_date: 5.days.from_now
        ),
      booked:
        create(:developer_in_project, :with_project_scheduled,
          project: project,
          scheduled_project: create(:project, :without_due_date),
          scheduled_membership_start: 5.days.from_now,
          membership_due_date: 5.days.from_now,
          booked: true
        )
    } }

    initialize_with { attributes }
  end
end
