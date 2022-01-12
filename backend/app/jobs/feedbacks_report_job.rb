# frozen_string_literal: true

class FeedbacksReportJob < ApplicationJob
  queue_as :default

  def perform
    FeedbackServices::GenerateReport.call
  end
end
