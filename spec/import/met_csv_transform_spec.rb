# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'TransformingMetropolitan Museum of Art CSV file' do
  let(:indexer) do
    Traject::Indexer.new('command_line.filename' => fixture_file_path,
                         'exhibit_slug' => slug,
                         'agg_provider' => 'Metropolitan Museum of Art',
                         'inst_id' => 'met').tap do |i|
      i.load_config_file('lib/traject/met_csv_config.rb')
    end
  end
  let(:fixture_file_path) { File.join(fixture_path, 'csv/met.csv') }
  let(:data) { File.open(fixture_file_path).read }
  let(:exhibit) { create(:exhibit) }
  let(:slug) { exhibit.slug }

  before do
    allow(CreateResourceJob).to receive(:perform_later)
  end

  it 'does the transform' do
    indexer.process(data)
    expect(CreateResourceJob).to have_received(:perform_later) do |_id, _two, json|
      dlme = JSON.parse(json)
      expect(dlme['agg_provider']).to eq 'Metropolitan Museum of Art'
      expect(dlme['id']).to eq 'met_321382'
    end
  end
end
