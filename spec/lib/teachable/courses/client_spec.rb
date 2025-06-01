require 'rails_helper'

RSpec.describe Teachable::Courses::Client do
  describe "#get" do
    context "when the request is successful" do
      it "returns a list of courses" do
        VCR.use_cassette("teachable_courses") do
          response = described_class.new.get
          expect(response.courses).to be_an(Array)
        end
      end

      it "returns the number of pages" do
        VCR.use_cassette("teachable_courses") do
          response = described_class.new.get
          expect(response.number_of_pages).to be_an(Integer)
        end
      end
    end

    context "when the request fails" do
      it "raises a NotOkResponse" do
        allow(Teachable::Base).to receive(:get).and_return(instance_double(HTTParty::Response, code: 500))

        expect { described_class.new.get }.to raise_error(Teachable::Base::NotOkResponse, /Failed to fetch courses with code 500/)
      end
    end
  end
end
