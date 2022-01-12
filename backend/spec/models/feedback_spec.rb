# frozen_string_literal: true

require "spec_helper"

RSpec.describe Feedback, type: :model do
  subject { build :feedback, :for_user }

  it { is_expected.to belong_to :commentable }
  it { is_expected.to validate_presence_of :comment }
end
