require 'spec_helper'

describe Api::V2::MembershipSerializer do
  let(:project) { create(:project) }
  let(:object) { create(:membership, project: project) }
  let(:hash) { described_class.new(object).serializable_hash }

  it { expect(hash[:project_name]).to eq(project.name) }
  include_examples 'attributes', %w(starts_at ends_at)
end
