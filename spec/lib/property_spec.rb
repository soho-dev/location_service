RSpec.describe Property do
  subject { described_class.new(formatted_address) }

  context "address eligible" do
    let(:formatted_address) { {"street"=>"212 encounter bay", "city"=>"Alameda", "zip"=>"90255", "state"=>"California", "county"=>"Alameda", "country"=>"United States"} }
    it "returns message" do
      expect(subject.eligible[:message]).to eq "address_eligible"
    end

    it "returns formatted address" do
      expect(subject.eligible[:formatted_address]).to eq formatted_address
    end
  end

  context "address not eligible" do
    let(:formatted_address) { {"street"=>"212 encounter bay", "city"=>"test", "county"=>"Alameda"} }
    it "returns message" do
      expect(subject.eligible[:message]).to eq "address not eligible"
    end
  end

  context "address not found" do
    let(:formatted_address) { nil }
    it "returns message" do
      expect(subject.eligible[:message]).to eq "address not found"
    end
  end
end
