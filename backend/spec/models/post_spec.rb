# frozen_string_literal: true

require "spec_helper"

RSpec.describe Post, type: :model do
  subject { build :post }

  it { is_expected.to belong_to :user }
  it { is_expected.to validate_length_of(:content).is_at_least 2 }
  it { is_expected.to validate_length_of(:content).is_at_most 256 }
  it { is_expected.to validate_presence_of :content }
  it { is_expected.to validate_length_of(:origin_ip).is_at_least 7 }
  it { is_expected.to validate_length_of(:origin_ip).is_at_most 15 }
  it { is_expected.to validate_presence_of :origin_ip }
  it { is_expected.to validate_length_of(:title).is_at_least 2 }
  it { is_expected.to validate_length_of(:title).is_at_most 256 }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_uniqueness_of(:title).case_insensitive }
end
