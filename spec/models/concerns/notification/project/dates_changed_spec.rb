require 'spec_helper'

describe Notification::Project::DatesChanged do
  let(:project) { create(:project) }

  describe '#message' do
    it 'returns nil if starts_at and end_at and kickoff not changed' do
      expect(described_class.new(project).message).to be_nil
    end

    it 'returns proper string if kickoff changed' do
      new_date = project.end_at + 1.day
      expected_notification = "Dates in project *#{project.name}* has been updated."\
        "\n*Kickoff* changed to _#{new_date.to_s(:ymd)}_."

      project.kickoff = new_date

      expect(described_class.new(project).message).to eql(expected_notification)
    end

    it 'returns proper string if starts_at changed' do
      new_date = project.end_at + 1.day
      expected_notification = "Dates in project *#{project.name}* has been updated."\
        "\n*Starts at* changed to _#{new_date.to_s(:ymd)}_."

      project.starts_at = new_date

      expect(described_class.new(project).message).to eql(expected_notification)
    end

    it 'returns proper string if end_at changed' do
      new_date = project.end_at + 1.day
      expected_notification = "Dates in project *#{project.name}* has been updated."\
        "\n*End at* changed to _#{new_date.to_s(:ymd)}_."

      project.end_at = new_date

      expect(described_class.new(project).message).to eql(expected_notification)
    end

    it 'returns proper string if all dates changed' do
      new_date = project.end_at + 1.day
      expected_notification = "Dates in project *#{project.name}* has been updated."\
        "\n*Kickoff* changed to _#{new_date.to_s(:ymd)}_."\
        "\n*Starts at* changed to _#{new_date.to_s(:ymd)}_."\
        "\n*End at* changed to _#{new_date.to_s(:ymd)}_."

      project.kickoff = new_date
      project.starts_at = new_date
      project.end_at = new_date

      expect(described_class.new(project).message).to eql(expected_notification)
    end

    it 'notifies with proper message if some date is changed to nil' do
      new_date = project.end_at + 1.day
      expected_notification = "Dates in project *#{project.name}* has been updated."\
        "\n*Kickoff* changed to _#{new_date.to_s(:ymd)}_.\n*End at* cleared."

      project.kickoff = new_date
      project.end_at = nil

      expect(described_class.new(project).message).to eql(expected_notification)
    end
  end
end
