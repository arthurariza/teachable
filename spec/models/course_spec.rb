require 'rails_helper'

RSpec.describe Course, type: :model do
  describe "validations" do
    subject { build(:course) }

    it { is_expected.to validate_presence_of(:external_id) }
    it { is_expected.to validate_uniqueness_of(:external_id) }
  end

  describe "associations" do
    it { is_expected.to have_many(:enrollments) }
    it { is_expected.to have_many(:users).through(:enrollments) }
  end
end
