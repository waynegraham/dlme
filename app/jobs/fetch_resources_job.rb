# frozen_string_literal: true

# Load JSON resources from a url, persist them, and index them
class FetchResourcesJob < ApplicationJob
  queue_as :default

  def perform(url, exhibit)
    resp = Faraday.get(url)

    resource = resp.body.split("\n")
    resource.each_with_index do |item, index|
      create_or_update_resource(item, exhibit, index)
    end
    logger.info("#{resource.count} records were created from #{url}.")
  end

  private

  def create_or_update_resource(item, exhibit, index)
    json = JSON.parse(item)
    resource = DlmeJson.find_or_initialize_by(url: json['id'], exhibit: exhibit)
    resource.data = { json: item }

    raise "Resource #{index + 1} in #{url} is not valid." unless resource.valid?

    resource.save
    resource.reindex
  end
end
