class Teachable::ImportJob < ApplicationJob
  def perform
    User::ImportService.call
    Course::ImportService.call
    Enrollment::ImportService.call
  end
end
