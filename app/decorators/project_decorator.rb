class ProjectDecorator < Draper::Decorator
  delegate_all

  def maintenance_visibility
    maintenance? ? '' : 'hidden'
  end
end
