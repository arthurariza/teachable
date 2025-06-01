class Enrollment::ImportService < ApplicationService
  def initialize(client: Teachable::Enrollments::Client.new)
    @client = client
    @enrollments = []
  end

  def call
    build_enrollments

    delete_all_enrollments

    create_enrollments
  end

  private

  def build_enrollments
    Course.find_each do |course|
      page_one = get_page(course.external_id, 1)

      build_enrollments_from_page(page_one, course.external_id)

      remaining_pages_from(page_one).each do |page_number|
        page = get_page(course.external_id, page_number)

        build_enrollments_from_page(page, course.external_id)
      end
    end
  end

  def get_page(course_external_id, page)
    @client.get(course_id: course_external_id, page: page)
  end

  def remaining_pages_from(page_one)
    (2..page_one.number_of_pages)
  end

  def build_enrollments_from_page(page, course_external_id)
    page.enrollments.each do |enrollment|
      @enrollments << {
        course_external_id: course_external_id,
        user_external_id: enrollment["user_id"]
      }
    end
  end

  def delete_all_enrollments
    Enrollment.delete_all
  end

  def create_enrollments
    Enrollment.create(@enrollments)
  end
end
