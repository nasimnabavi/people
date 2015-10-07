module Notification::Project
  class DatesChanged
    attr_reader :project

    def initialize(project)
      @project = project
    end

    def message
      kickoff_changed = field_changed?(:kickoff)
      starts_at_changed = field_changed?(:starts_at)
      end_at_changed = field_changed?(:end_at)

      return unless kickoff_changed || starts_at_changed || end_at_changed

      notification = ["Dates in project *#{project.name}* has been updated."]
      notification << field_changed_msg(:kickoff) if kickoff_changed
      notification << field_changed_msg(:starts_at) if starts_at_changed
      notification << field_changed_msg(:end_at) if end_at_changed
      notification.join("\n")
    end

    private

    def field_changed?(field)
      project.changes[field].present? && project.changes[field][0] != project.changes[field][1]
    end

    def field_changed_msg(field)
      if project.changes[field].to_a[1].present?
        "*#{field.to_s.humanize}* changed to _#{project.send(field).to_s(:ymd)}_."
      else
        "*#{field.to_s.humanize}* cleared."
      end
    end
  end
end
