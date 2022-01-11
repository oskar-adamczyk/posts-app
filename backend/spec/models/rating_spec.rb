# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rating, type: :model do
  subject { build :rating }

  it { is_expected.to belong_to :post }
  it { is_expected.to validate_numericality_of(:rate).is_greater_than_or_equal_to(1).only_integer }
  it { is_expected.to validate_numericality_of(:rate).is_less_than_or_equal_to(5).only_integer }
end
