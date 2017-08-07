# frozen_string_literal: true

##
# Creating new DLME JSON items
class DlmeJsonsController < Spotlight::ApplicationController
  helper :all

  before_action :authenticate_user!

  load_and_authorize_resource :exhibit, class: Spotlight::Exhibit
  before_action :build_resource

  load_and_authorize_resource class: 'DlmeJsons', through_association: 'exhibit.resources', instance_name: 'resource'

  def create
    @resource.attributes = resource_params
    if @resource.save_and_index
      flash[:notice] = t('spotlight.resources.upload.success')
      redirect_to spotlight.admin_exhibit_catalog_path(current_exhibit)
    else
      flash[:error] = t('spotlight.resources.upload.error')
      redirect_to spotlight.new_exhibit_resource_path(current_exhibit)
    end
  end

  private

  def build_resource
    @resource ||= DlmeJson.new exhibit: current_exhibit
  end

  def resource_params
    params.require(:dlme_json).permit(data: [:json])
  end
end
