require 'spec_helper'

describe Role do
  subject { build(:role) }

  it { should have_many :memberships }
  it { should validate_presence_of(:name) }
  it { should be_valid }

  describe 'callbacks' do
    describe 'before_destroy' do
      let!(:role) { create(:role) }
      let!(:membership) { create(:membership, role: role) }

      it 'returns error that there are still memberships' do
        expect(role.destroy).to eq false
      end
    end
  end

  describe "#to_s" do
    it "returns name" do
      subject.name = "junior"
      expect(subject.to_s).to eq("junior")
    end
  end
end
