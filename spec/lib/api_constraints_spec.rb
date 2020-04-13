RSpec.describe ApiConstraints do
  subject { described_class.new(version: "35") }

  describe "#matches?" do
    context "default is true" do
      subject { described_class.new(version: "35", default: true) }

      it "returns true if default" do
        expect(subject.matches?(:a_request)).to eq(true)
      end
    end

    context "default is not true" do
      it "returns true if version equals major version from request" do
        allow(subject).to receive(:version_from_request)
          .with(:a_request)
          .and_return(double(RequestedVersion, major: 35))
        expect(subject.matches?(:a_request)).to eq(true)
      end

      it "returns true if version does not equal major version from request" do
        allow(subject).to receive(:version_from_request)
          .with(:a_request)
          .and_return(double(RequestedVersion, major: 26))
        expect(subject.matches?(:a_request)).to eq(false)
      end

      it "returns false if no major version in request" do
        allow(subject).to receive(:version_from_request)
          .with(:a_request)
          .and_return(nil)
        expect(subject.matches?(:a_request)).to eq(false)
      end
    end
  end

  describe "#version_from_request" do
    it "returns nil if no version header" do
      allow(subject).to receive(:api_version_header_from_request)
        .with(:the_request)
        .and_return(nil)
      expect(subject.version_from_request(:the_request)).to be_nil
    end

    it "returns RequestedVersion instance with version from request" do
      allow(subject).to receive(:api_version_header_from_request)
        .with(:the_request)
        .and_return("salt")
      allow(RequestedVersion).to receive(:new)
        .with("salt")
        .and_return(:the_requested_version)
      expect(subject.version_from_request(:the_request)).to eq(:the_requested_version)
    end
  end

  describe "#api_version_header_from_request" do
    let(:request) {
      double(Rack::Request, headers: {
        "Api-Version" => "1234",
        "HTTP_X_API_VERSION" => "5678",
        "HTTP_API_VERSION" => "911"
      })
    }

    it "returns Api-Version header from request" do
      expect(subject.api_version_header_from_request(request)).to eq("1234")
    end

    it "cascades to HTTP_X_API_VERSION header" do
      allow(request).to receive(:headers).and_return(request.headers.except("Api-Version"))
      expect(subject.api_version_header_from_request(request)).to eq("5678")
    end

    it "cascades to HTTP_API_VERSION header" do
      allow(request).to receive(:headers).and_return(request.headers.slice("HTTP_API_VERSION"))
      expect(subject.api_version_header_from_request(request)).to eq("911")
    end
  end
end
