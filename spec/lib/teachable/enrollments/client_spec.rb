require 'rails_helper'

RSpec.describe Teachable::Enrollments::Client do
  describe "#get" do
    context "when the request is successful" do
      it "returns a list of enrollments" do
        VCR.use_cassette("teachable_enrollments") do
          response = described_class.new.get(course_id: 2002430)
          expect(response.enrollments).to be_an(Array)
        end
      end

      it "returns the number of pages" do
        VCR.use_cassette("teachable_enrollments") do
          response = described_class.new.get(course_id: 2002430)
          expect(response.number_of_pages).to be_an(Integer)
        end
      end
    end

    context "when the request returns a 404" do
      before do
        allow(Teachable::Base).to receive(:get).and_return(instance_double(HTTParty::Response, code: 404))
      end

      it "returns an empty list of enrollments" do
        response = described_class.new.get(course_id: 1)
        expect(response.enrollments).to be_an(Array)
      end

      it "returns 1 page" do
        response = described_class.new.get(course_id: 1)
        expect(response.number_of_pages).to eq(1)
      end
    end

    context "when the request fails" do
      it "raises a NotOkResponse" do
        allow(Teachable::Base).to receive(:get).and_return(instance_double(HTTParty::Response, code: 500))

        expect { described_class.new.get(course_id: 2002430) }.to raise_error(Teachable::Base::NotOkResponse, /Failed to fetch enrollments with code 500/)
      end
    end
  end
end
