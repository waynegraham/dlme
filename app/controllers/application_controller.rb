# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include Spotlight::Controller

  layout 'blacklight'

  protect_from_forgery with: :exception

  # This can be removed after upgrading to Blacklight 7
  skip_after_action :discard_flash_if_xhr
end
