shared_examples 'attributes' do |attributes|
  describe 'standard attributes' do
    let(:hash) { described_class.new(object).serializable_hash }
    attributes.each do |attribute|
      it "includes #{attribute} attribute" do
        expect(hash[attribute.to_sym]).to eq(object.try(attribute))
      end
    end
  end
end
