class Course < ApplicationRecord
  validates :external_id, presence: true, uniqueness: true

  has_many :enrollments, foreign_key: :course_external_id, primary_key: :external_id
  has_many :users, through: :enrollments
end
