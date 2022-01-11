# frozen_string_literal: true

require "spec_helper"

RSpec.describe Post, type: :model do
  subject { build :post }

  [
    *%w[1 10 100].repeated_permutation(4).map { |ip_parts| ip_parts.join(".") }.map { |ip| [ip, :be_valid] },
    *%w[0,0.0.0 0000.0.0.0 0.0.0].map { |ip| [ip, :be_invalid] }
  ].each do |ip, expect|
    it "expects ip '#{ip}' to #{expect.to_s.humanize.downcase}" do
      expect(subject.tap { |post| post.assign_attributes(origin_ip: ip) }).to send expect
    end
  end
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
