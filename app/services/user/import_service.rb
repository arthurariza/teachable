class User::ImportService < ApplicationService
  def initialize(client: Teachable::Users::Client.new)
    super()

    @client = client
    @users = []
  end

  def call
    page_one = get_page(1)

    build_users_from_page(page_one)

    remaining_pages_from(page_one).each do |page|
      result = get_page(page)

      build_users_from_page(result)
    end

    upsert_users
  end

  private

  def get_page(page)
    @client.get(page: page)
  end

  def build_users_from_page(page)
    page.users.each do |user|
      @users << build_user(user["name"], user["email"], user["id"])
    end
  end

  def remaining_pages_from(page_one)
    (2..page_one.number_of_pages)
  end

  def build_user(name, email, external_id)
    {
      name: name,
      email: email,
      external_id: external_id
    }
  end

  def upsert_users
    User.upsert_all(@users, unique_by: :external_id)
  end
end
