describe Api::V1::AddressEligibilitiesController, type: :controller do
  describe "#eligible" do
    context "address is missing" do
      it "should return address missing response" do
        post :eligible, params: { financing_application_id: "bad" }
        expect(JSON.parse(response.body)).to eq("message" => "address missing")
      end
    end
  end
end
