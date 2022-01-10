# frozen_string_literal: true

require "spec_helper"

RSpec.describe User, type: :model do
  subject { build :user }

  [
    *["a@b.pl", "a@b.pl.co", "test@example.com", "a@b.pl#{248.times.map { 'a' }.join}"].map do |email|
      [email, :be_valid]
    end,
    *["@b.pl", "a@.pl", "a@bpl", "a@b.p", "amb.coms", "ambcoms", "a@b.pl#{249.times.map { 'a' }.join}"].map do |email|
      [email, :be_invalid]
    end
  ].each do |email, expect|
    it "expects email '#{email}' to #{expect.to_s.humanize.downcase}" do
      expect(subject.tap { |user| user.assign_attributes(email: email) }).to send expect
    end
  end
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
end
