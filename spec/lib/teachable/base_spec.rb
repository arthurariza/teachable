require 'rails_helper'

RSpec.describe Teachable::Base do
  describe 'base_uri' do
    it 'returns the correct base uri' do
      expect(described_class.base_uri).to eq('https://developers.teachable.com')
    end
  end

  describe 'headers' do
    it 'returns the correct headers' do
      expect(described_class.headers).to eq({
        'Accept' => 'application/json',
        'apiKey' => 'api_key'
      })
    end
  end
end
