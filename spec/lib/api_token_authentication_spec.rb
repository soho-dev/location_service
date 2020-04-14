RSpec.describe ApiTokenAuthentication do

  let(:api_token) { "00000-000-00000" }

  subject { described_class.new(api_token: api_token) }

  describe "#initialize" do
    it "should not raise an exception" do
      expect{subject}.to_not raise_error
    end
  end

  context "missing api token" do
    let(:api_token) { nil }
    describe "#initialize" do
      it "should raise an exception" do
        expect{subject}.to raise_error(ApiTokenAuthentication::MissingToken)
      end
    end
  end

  context "invalid api token" do
    let(:api_token) { "XXXXXXXX-1111-XXXX-1111-XXXXXXXXXXXX" }

    describe "#authenticate" do
      it "should raise an exception" do
        expect{ subject.authenticate }.to raise_error(ApiTokenAuthentication::TokenMismatch)
      end
    end
  end

  context "valid api token" do
    let(:api_token) { "00000-000-00000" }
    describe "#authenticate" do
      it "looks through a list of tokens to find the token" do
        allow(described_class)
          .to receive(:valid_api_tokens)
          .and_return(["11111-111-11111",
                       "00000-000-00000"])

        expect{ subject.authenticate }.to_not raise_error
      end

      it "doesn't mind if the token is at the end of the list" do
        allow(described_class)
          .to receive(:valid_api_tokens)
          .and_return(["00000-000-00000",
                       "11111-111-11111"])

        expect{ subject.authenticate }.to_not raise_error
      end
    end
  end

  it ".config" do
    expect(described_class.config).to eq YAML.load(ERB.new(File.read(File.join(Rails.root, 'config', 'api_token.yml'))).result)
  end

  it ".valid_api_tokens" do
    expect(described_class.valid_api_tokens).to eq ["00000-000-00000", "11111-111-11111"]
  end

end
