# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'transform results', type: :request do
  context 'when signed in' do
    let(:curator) { create(:exhibit_curator) }

    before do
      sign_in curator
    end

    it 'shows transform results' do
      get '/transform_result'
      expect(response).to have_http_status(:ok)
    end
  end

  context 'when POSTing to create' do
    let(:msg) do
      '{"Message": "{\n  \"success\": true,\n  \"records\": 1,\n  \"data_path\": \"stanford/maps/data/' \
      'kj751hs0595.mods\",\n  \"timestamp\": \"2019-02-22T19:04:24+00:00\",\n  \"duration\": 0,\n  \"url\": ' \
      '\"http://localstack:4572/dlme-transform/output-20190222190423.ndjson\"\n}\n", "Type": "Notification", ' \
      '"TopicArn": "arn:aws:sns:us-east-1:123456789012:dlme-transform", "MessageId": "8456e5c9-2fcf-4866-9c4f-b5bf3b898938"}'
    end

    # The SNS https endpoint is setting Content-Type to 'text/plain' even though it's pushing JSON.
    # See https://forums.aws.amazon.com/thread.jspa?threadID=69413
    let(:headers) { { 'Content-Type' => 'text/plain' } }

    before do
      allow(TransformResult).to receive(:create)
    end

    # rubocop:disable RSpec/ExampleLength
    it 'creates the TransformResult' do
      post '/transform_result', params: msg, headers: headers
      expect(TransformResult).to have_received(:create).with(
        url: 'http://localstack:4572/dlme-transform/output-20190222190423.ndjson',
        data_path: 'stanford/maps/data/kj751hs0595.mods',
        success: true,
        records: 1,
        timestamp: DateTime.iso8601('2019-02-22T19:04:24+00:00'),
        duration: 0,
        error: nil
      )
      expect(response).to have_http_status(:created)
    end
    # rubocop:enable RSpec/ExampleLength
  end
end