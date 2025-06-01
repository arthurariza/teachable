class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show ]

  # GET /courses
  def index
    @courses = Course.all
  end

  # GET /courses/1
  def show
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find(params.expect(:id))
  end
end
