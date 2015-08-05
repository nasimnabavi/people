class UnavailableProjectBuilder
  def call
    Project.unavailable.first_or_create! do |project|
      project.assign_attributes(unavailable_project_attributes)
    end
  end

  private

  def unavailable_project_attributes
    {
      name: 'unavailable',
      project_type: 'regular',
    }
  end
end
