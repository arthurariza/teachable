require "rails_helper"

RSpec.describe Course::ImportService do
  let(:client) { instance_double(Teachable::Courses::Client) }

  describe "#call" do
    context "when there is only one page of courses" do
      let(:course_data) do
        [
          { "id" => 1, "name" => "Ruby Course", "heading" => "Learn Ruby", "is_published" => true },
          { "id" => 2, "name" => "Rails Course", "heading" => "Learn Rails", "is_published" => true }
        ]
      end

      let(:page_response) do
        instance_double(
          Teachable::Courses::Client::Result,
          courses: course_data,
          number_of_pages: 1
        )
      end

      before do
        allow(client).to receive(:get).with(page: 1).and_return(page_response)
      end

      it "creates course records from the API response" do
        expect { described_class.call(client: client) }.to change(Course, :count).by(2)
      end
    end

    context "when there are multiple pages of courses" do
      let(:first_page_courses) do
        [
          { "id" => 1, "name" => "Ruby Course", "heading" => "Learn Ruby", "is_published" => true },
          { "id" => 2, "name" => "Rails Course", "heading" => "Learn Rails", "is_published" => true }
        ]
      end

      let(:second_page_courses) do
        [
          { "id" => 3, "name" => "JavaScript Course", "heading" => "Learn JS", "is_published" => true },
          { "id" => 4, "name" => "React Course", "heading" => "Learn React", "is_published" => false }
        ]
      end

      let(:first_page_response) do
        instance_double(
          Teachable::Courses::Client::Result,
          courses: first_page_courses,
          number_of_pages: 2
        )
      end

      let(:second_page_response) do
        instance_double(
          Teachable::Courses::Client::Result,
          courses: second_page_courses,
          number_of_pages: 2
        )
      end

      before do
        allow(client).to receive(:get).with(page: 1).and_return(first_page_response)
        allow(client).to receive(:get).with(page: 2).and_return(second_page_response)
      end

      it "fetches the first page of courses from the API" do
        described_class.call(client: client)

        expect(client).to have_received(:get).with(page: 1)
      end

      it "fetches the second page of courses from the API" do
        described_class.call(client: client)

        expect(client).to have_received(:get).with(page: 2)
      end

      it "creates course records from all pages" do
        expect { described_class.call(client: client) }.to change(Course, :count).by(4)
      end
    end

    context "when there are already courses in the database" do
      let(:course_data) do
        [
          { "id" => 1, "name" => "Updated Ruby Course", "heading" => "Advanced Ruby", "is_published" => true },
          { "id" => 3, "name" => "New JavaScript Course", "heading" => "Learn JS", "is_published" => true }
        ]
      end

      let(:page_response) do
        instance_double(
          Teachable::Courses::Client::Result,
          courses: course_data,
          number_of_pages: 1
        )
      end

      before do
        allow(client).to receive(:get).with(page: 1).and_return(page_response)
      end

      it "updates existing courses and adds new ones" do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        create(:course, name: "Ruby Course", heading: "Learn Ruby", is_published: true, external_id: 1)
        create(:course, name: "Rails Course", heading: "Learn Rails", is_published: true, external_id: 2)

        described_class.call(client: client)

        updated_course = Course.find_by(external_id: 1)
        expect(updated_course.name).to eq("Updated Ruby Course")
        expect(updated_course.heading).to eq("Advanced Ruby")

        unchanged_course = Course.find_by(external_id: 2)
        expect(unchanged_course.name).to eq("Rails Course")

        new_course = Course.find_by(external_id: 3)
        expect(new_course).to be_present
        expect(new_course.name).to eq("New JavaScript Course")

        expect(Course.count).to eq(3)
      end
    end
  end
end
