# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransformsController do
  let(:exhibit) { create(:exhibit) }
  let(:curator) { create(:exhibit_curator, exhibit: exhibit) }

  before do
    sign_in curator
  end

  describe 'GET show' do
    it 'is successful' do
      get :show
      expect(response).to be_successful
    end
  end

  describe 'POST create' do
    let(:data_dir) { 'stanford/maps' }

    before do
      allow(TransformNotification).to receive(:publish)
    end

    it 'redirects to the list page' do
      post :create, params: { data_dir: data_dir }
      expect(TransformNotification).to have_received(:publish).with(data_dir)
      expect(flash[:notice]).to be_present
      expect(response).to redirect_to transform_path
    end
  end
end
