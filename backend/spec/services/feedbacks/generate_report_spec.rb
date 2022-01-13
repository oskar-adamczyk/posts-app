# frozen_string_literal: true

require "spec_helper"

describe FeedbackServices::GenerateReport do
  subject { described_class.call }

  let!(:feedbacks) { [] }
  let(:now) { Time.zone.now }
  let(:expected_feedbacks) { Feedback.left_joins(:post).order(created_at: :desc) }
  let(:expected_xml_content) do
    expected_feedbacks.all.map do |feedback|
      {
        comment: feedback.comment,
        owner: feedback.owner.email,
        rating: feedback.post&.average_rate,
        type: feedback.commentable_type
      }
    end.to_xml skip_instruct: true
  end

  before { allow_any_instance_of(ActiveSupport::TimeZone).to receive(:now).and_return now }
  after { subject }

  it {
    expect(File).to receive(:write).with "tmp/feedbacks_reports/#{now.iso8601}_feedbacks-report.xml",
                                         expected_xml_content
  }

  context "with submitted feedbacks" do
    let!(:feedbacks) do
      {
        for_post: create(:feedback, :for_post),
        for_post_with_rate: create(:feedback, commentable: create(:post, average_rate: 1.5)),
        for_user: create(:feedback, :for_user)
      }
    end
    it {
      expect(File).to receive(:write).with "tmp/feedbacks_reports/#{now.iso8601}_feedbacks-report.xml",
                                           expected_xml_content
    }
  end
end
