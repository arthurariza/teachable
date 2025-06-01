class User < ApplicationRecord
  validates :external_id, presence: true, uniqueness: true

  has_many :enrollments, foreign_key: :user_external_id, primary_key: :external_id
  has_many :courses, through: :enrollments
end
