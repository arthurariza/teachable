require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:external_id) }
    it { is_expected.to validate_uniqueness_of(:external_id) }
  end

  describe "associations" do
    it { is_expected.to have_many(:enrollments) }
    it { is_expected.to have_many(:courses).through(:enrollments) }
  end
end
