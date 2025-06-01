class Teachable::Users::Client < Teachable::Base
  USERS_ENDPOINT = "/v1/users"

  Result = Struct.new(:users, :number_of_pages, keyword_init: true)


  def get(page: 1)
    response = self.class.get(USERS_ENDPOINT, query: { page: page })

    if response.code == 200
      Result.new(users: response["users"], number_of_pages: response["meta"]["number_of_pages"])
    else
      raise NotOkResponse, "Failed to fetch users with code #{response.code}"
    end
  end
end
