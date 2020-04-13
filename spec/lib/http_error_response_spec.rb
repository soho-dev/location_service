require_relative "../../lib/http_error_response"

RSpec.describe HttpErrorResponse do
  describe "#response_code" do
    before do
      allow(subject).to receive(:status_symbol).and_return(:network_authentication_required)
    end

    it { expect(subject.response_code).to eq(511) }
  end

  context "a child inherits the status of their parents" do
    class TestErrorResponse1 < HttpErrorResponse
    end

    it { expect(TestErrorResponse1.status_symbol).to eq(:internal_server_error) }
    it { expect(TestErrorResponse1.new.status_symbol).to eq(:internal_server_error) }
    it { expect(TestErrorResponse1.new.response_code).to eq(500) }
  end

  context "a child can override their parents status" do
    class TestErrorResponse2 < HttpErrorResponse
      self.status_symbol = :loop_detected
    end

    it { expect(TestErrorResponse2.status_symbol).to eq(:loop_detected) }
    it { expect(TestErrorResponse2.new.status_symbol).to eq(:loop_detected) }
    it { expect(TestErrorResponse2.new.response_code).to eq(508) }
  end
end
