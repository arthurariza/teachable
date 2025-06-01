class Teachable::Courses::Client < Teachable::Base
  COURSES_ENDPOINT = "/v1/courses"

  Result = Struct.new(:courses, :number_of_pages, keyword_init: true)


  def get(page: 1)
    response = self.class.get(COURSES_ENDPOINT, query: { page: page })

    if response.code == 200
      Result.new(courses: response["courses"], number_of_pages: response["meta"]["number_of_pages"])
    else
      raise NotOkResponse, "Failed to fetch courses with code #{response.code}"
    end
  end
end
