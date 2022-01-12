# frozen_string_literal: true

require "spec_helper"

describe FeedbacksReportJob do
  subject { described_class.perform_now }

  after { subject }

  it { expect(FeedbackServices::GenerateReport).to receive(:call).with no_args }
end
