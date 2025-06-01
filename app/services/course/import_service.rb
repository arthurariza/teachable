class Course::ImportService < ApplicationService
  def initialize(client: Teachable::Courses::Client.new)
    super()

    @client = client
    @courses = []
  end

  def call
    page_one = get_page(1)

    build_courses_from_page(page_one)

    remaining_pages_from(page_one).each do |page_number|
      page = get_page(page_number)

      build_courses_from_page(page)
    end

    upsert_courses
  end

  private

  def get_page(page)
    @client.get(page: page)
  end

  def build_courses_from_page(page)
    page.courses.each do |course|
      @courses << build_course(course["name"], course["heading"], course["is_published"], course["id"])
    end
  end

  def remaining_pages_from(page_one)
    (2..page_one.number_of_pages)
  end

  def build_course(name, heading, is_published, external_id)
    {
      name: name,
      heading: heading,
      is_published: is_published,
      external_id: external_id
    }
  end

  def upsert_courses
    Course.upsert_all(@courses, unique_by: :external_id)
  end
end
