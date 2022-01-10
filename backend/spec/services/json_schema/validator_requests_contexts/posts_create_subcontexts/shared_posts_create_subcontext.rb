# frozen_string_literal: true

RSpec.shared_context "validating base posts create", shared_context: :metadata do
  context "validating base posts create" do
    context "with valid attributes" do
      it { expect { subject }.not_to raise_error }
    end

    [
      [{ data: { attributes: {} } }, "with missing attributes"],
      [{ data: {} }, "missing attributes object"],
      [{}, "missing data object"]
    ].each do |attributes, description|
      context "with #{description}" do
        let(:body) { attributes }

        it { expect { subject }.to raise_error Errors::BadRequest }
      end
    end

    context "with invalid, singular type" do
      let(:type) { "post" }

      it { expect { subject }.to raise_error Errors::BadRequest }
    end
  end
end
