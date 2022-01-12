# frozen_string_literal: true

module FeedbackServices
  class GenerateReport < BaseService
    class Result < BaseServiceResult
      attribute :feedbacks_ids, Strict::Array.of(String)
    end

    private

    def perform
      xml_content = feedbacks.all.map do |feedback|
        {
          comment: feedback.comment,
          owner: feedback.owner.email,
          rating: feedback.post&.average_rate,
          type: feedback.commentable_type
        }
      end.to_xml skip_instruct: true

      File.write("tmp/#{Time.zone.now.iso8601}_feedbacks-report.xml", xml_content)

      Result.new feedbacks_ids: feedbacks.pluck(:id)
    end

    def feedbacks
      @feedbacks ||= Feedback.left_joins(:post).order(created_at: :desc)
    end
  end
end
