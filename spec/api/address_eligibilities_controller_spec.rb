describe Api::AddressEligibilitiesController, type: :controller do
  describe "#eligible" do

    context "address is missing" do
      it "should return address missing response" do
        post :show, params: { financing_application_id: "bad" }
      end
    end
  end
end
