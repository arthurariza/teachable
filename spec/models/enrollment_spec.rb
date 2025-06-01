require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:course) }
    it { is_expected.to belong_to(:user) }
  end
end
