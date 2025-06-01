require 'rails_helper'

RSpec.describe Enrollment::ImportService do
  let(:client) { instance_double(Teachable::Enrollments::Client) }
  let(:course) { create(:course) }

  describe "#call" do
    it "deletes all enrollments before importing" do
      allow(Enrollment).to receive(:delete_all)

      described_class.call(client: client)

      expect(Enrollment).to have_received(:delete_all)
    end

    context "when there is only one page of enrollments" do
      let(:enrollment_data) do
        [
          { "user_id" => create(:user).external_id },
          { "user_id" => create(:user).external_id }
        ]
      end

      let(:page_response) do
        instance_double(
          Teachable::Enrollments::Client::Result,
          enrollments: enrollment_data,
          number_of_pages: 1
        )
      end

      before do
        allow(client).to receive(:get).with(course_id: course.external_id, page: 1).and_return(page_response)
      end

      it "creates enrollment records from the API response" do
        expect { described_class.call(client: client) }.to change(Enrollment, :count).by(2)
      end
    end

    context "when there are multiple pages of enrollments" do
      let(:first_page_response) do
        instance_double(
          Teachable::Enrollments::Client::Result,
          enrollments: [
            { "user_id" => create(:user).external_id },
            { "user_id" => create(:user).external_id }
          ],
          number_of_pages: 2
        )
      end

      let(:second_page_response) do
        instance_double(
          Teachable::Enrollments::Client::Result,
          enrollments: [
            { "user_id" => create(:user).external_id },
            { "user_id" => create(:user).external_id }
          ],
          number_of_pages: 2
        )
      end

      before do
        allow(client).to receive(:get).with(course_id: course.external_id, page: 1).and_return(first_page_response)
        allow(client).to receive(:get).with(course_id: course.external_id, page: 2).and_return(second_page_response)
      end

      it "fetches the first page of enrollments from the API" do
        described_class.call(client: client)

        expect(client).to have_received(:get).with(course_id: course.external_id, page: 1)
      end

      it "fetches the second page of enrollments from the API" do
        described_class.call(client: client)

        expect(client).to have_received(:get).with(course_id: course.external_id, page: 2)
      end

      it "creates enrollment records from all pages" do
        expect { described_class.call(client: client) }.to change(Enrollment, :count).by(4)
      end
    end
  end
end
