require "rails_helper"

RSpec.describe User::ImportService do
  let(:client) { instance_double(Teachable::Users::Client) }

  describe "#call" do
    context "when there is only one page of users" do
      let(:user_data) do
        [
          { "id" => 1, "name" => "Greny Jakob", "email" => "greny.jakob@example.com" },
          { "id" => 2, "name" => "Lily Grace", "email" => "lily.grace@example.com" }
        ]
      end

      let(:page_response) do
        instance_double(
          Teachable::Users::Client::Result,
          users: user_data,
          number_of_pages: 1
        )
      end

      before do
        allow(client).to receive(:get).with(page: 1).and_return(page_response)
      end

      it "creates user records from the API response" do
        expect { described_class.call(client: client) }.to change(User, :count).by(2)
      end
    end

    context "when there are multiple pages of users" do
      let(:first_page_users) do
        [
          { "id" => 1, "name" => "Greny Jakob", "email" => "greny.jakob@example.com" },
          { "id" => 2, "name" => "Lily Grace", "email" => "lily.grace@example.com" }
        ]
      end

      let(:second_page_users) do
        [
          { "id" => 3, "name" => "Glenys Grace", "email" => "glenys.grace@example.com" },
          { "id" => 4, "name" => "Luna June", "email" => "luna.june@example.com" }
        ]
      end

      let(:first_page_response) do
        instance_double(
          Teachable::Users::Client::Result,
          users: first_page_users,
          number_of_pages: 2
        )
      end

      let(:second_page_response) do
        instance_double(
          Teachable::Users::Client::Result,
          users: second_page_users,
          number_of_pages: 2
        )
      end

      before do
        allow(client).to receive(:get).with(page: 1).and_return(first_page_response)
        allow(client).to receive(:get).with(page: 2).and_return(second_page_response)
      end

      it "fetches the first page of users from the API" do
        described_class.call(client: client)

        expect(client).to have_received(:get).with(page: 1)
      end

      it "fetches the second page of users from the API" do
        described_class.call(client: client)

        expect(client).to have_received(:get).with(page: 2)
      end

      it "creates user records from all pages" do
        expect { described_class.call(client: client) }.to change(User, :count).by(4)
      end
    end

    context "when there are already users in the database" do
      let(:user_data) do
        [
          { "id" => 1, "name" => "Greny Jakob", "email" => "greny.jakob@example.com" },
          { "id" => 3, "name" => "Glenys Grace", "email" => "glenys.grace@example.com" }
        ]
      end

      let(:page_response) do
        instance_double(
          Teachable::Users::Client::Result,
          users: user_data,
          number_of_pages: 1
        )
      end

      before do
        allow(client).to receive(:get).with(page: 1).and_return(page_response)
      end

      it "updates existing users and adds new ones" do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        create(:user, name: "Greny Jakob", email: "greny.jakob@test.com", external_id: 1)
        create(:user, name: "Lily Grace", email: "lily.grace@test.com", external_id: 2)

        described_class.call(client: client)

        updated_user = User.find_by(external_id: 1)
        expect(updated_user.name).to eq("Greny Jakob")
        expect(updated_user.email).to eq("greny.jakob@example.com")

        unchanged_user = User.find_by(external_id: 2)
        expect(unchanged_user.name).to eq("Lily Grace")
        expect(unchanged_user.email).to eq("lily.grace@test.com")

        new_user = User.find_by(external_id: 3)
        expect(new_user).to be_present
        expect(new_user.name).to eq("Glenys Grace")
        expect(new_user.email).to eq("glenys.grace@example.com")

        expect(User.count).to eq(3)
      end
    end
  end
end
