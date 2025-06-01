class Teachable::Enrollments::Client < Teachable::Base
  Result = Struct.new(:enrollments, :number_of_pages, keyword_init: true)


  def get(course_id:, page: 1)
    response = self.class.get("/v1/courses/#{course_id}/enrollments", query: { page: page })

    case response.code
    when 200
      Result.new(enrollments: response["enrollments"], number_of_pages: response["meta"]["number_of_pages"])
    when 404
      Result.new(enrollments: [], number_of_pages: 1)
    else
      raise NotOkResponse, "Failed to fetch enrollments with code #{response.code}"
    end
  end
end
