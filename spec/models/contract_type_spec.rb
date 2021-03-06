describe ContractType do
  subject { build(:contract_type) }

  it { should have_many :users }
  it { should validate_presence_of(:name) }
  it { should be_valid }

  describe "#to_s" do
    it "returns name" do
      subject.name = "DG"
      expect(subject.to_s).to eq("DG")
    end
  end
end
