RSpec.describe AddressLookup do
  context "address search from cache" do
    let(:address) { "212 encounter bay" }
    let(:full_address) {
      {
        "street"=>"212 encounter bay",
        "city"=>"Alameda",
        "zip"=>"90255",
        "state"=>"California",
        "county"=>"Alameda",
        "country"=>"United States"
      }
    }

    it "returns result with all components in address" do
      expect(described_class.lookup(address)).to eq(full_address)
    end
  end
end
