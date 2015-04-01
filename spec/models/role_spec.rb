describe Role do
  subject { build(:role) }

  it { should have_many :memberships }
  it { should validate_presence_of(:name) }
  it { should be_valid }

  describe "#to_s" do
    it "returns name" do
      subject.name = "junior"
      expect(subject.to_s).to eq("junior")
    end
  end
end
