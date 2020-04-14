describe Api::V1::AddressEligibilitiesController, type: :controller do
  describe "#eligible" do
    let(:valid_headers) {{ "HTTP_API_TOKEN" => "00000-000-00000" }}
    let(:invalid_headers) {{"HTTP_API_TOKEN" => "invalid"}}

    let(:eligible_response) {
      {
        "formatted_address" =>
        {
          "city" => "Alameda",
          "country" => "United States",
          "county" => "Alameda",
          "state" => "California",
          "street" => "212 encounter bay",
          "zip" => "90255"
        },
        "message" => "address is eligible"
      }
    }
    let(:non_eligible_response) {
      {
        "formatted_address" =>
          {
            "street" => "123 Test",
            "city" => "Hunting Park",
            "zip" => "90255",
            "state" => "California",
            "county" => "Washington",
            "country" => "United States",
          },
        "message" => "address not eligible"
      }
    }
    let(:not_found_response) {
      {
        "message" => "Address Not found"
      }
    }

    context "address is missing" do
      it "should return address missing response" do
        post :eligible, params: { address: "" }
        expect(JSON.parse(response.body)).to eq("message" => "address missing")
      end
    end

    context "address is eligible" do
      it "should return address eligible response" do
        request.headers.merge!(valid_headers)
        post :eligible, params: { address: "212 encounter bay" }
        expect(JSON.parse(response.body)).to eq(eligible_response)
      end
    end

    context "address is not eligible" do
      it "should return address not eligible response" do
        request.headers.merge!(valid_headers)
        post :eligible, params: { address: "123 Test, Hunting Park" }
        expect(JSON.parse(response.body)).to eq(non_eligible_response)
      end
    end

    context "address not found" do
      it "should return address not found response" do
        request.headers.merge!(valid_headers)
        post :eligible, params: { address: "fake address" }
        expect(JSON.parse(response.body)).to eq(not_found_response)
      end
    end

    context "return invalid header response" do
      it "should return api token invalid" do
        request.headers.merge!(invalid_headers)
        post :eligible, params: { address: "fake address" }
        expect(JSON.parse(response.body)).to eq({"message"=>"Invalid API token"})
      end
    end

    context "return api token missing" do
      it "should return api token missing" do
        request.headers.merge!({})
        post :eligible, params: { address: "fake address" }
        expect(JSON.parse(response.body)).to eq({"message"=>"Must provide API token"})
      end
    end
  end
end
