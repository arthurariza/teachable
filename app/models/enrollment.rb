class Enrollment < ApplicationRecord
  belongs_to :course, foreign_key: :course_external_id, primary_key: :external_id
  belongs_to :user, foreign_key: :user_external_id, primary_key: :external_id
end
