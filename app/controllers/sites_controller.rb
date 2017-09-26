class SitesController < ApplicationController
  before_action :authenticate

  def index
    sites = Site.where(user: @user)
    render json: sites, status: 200
  end

  def create
    site = Site.new(site_params)
    site.user = @user
    begin
      site.save!
      render json: site, status: 201
    rescue
      render plain: site.errors.full_messages.to_s, status: 400
    end
  end

  def update
    if site = @user.site.find(params[:site_id])
      begin
        params_copy = site_params
        params_copy.delete :site_id
        site.update_attributes(params_copy)
        render json: site, status: 200
      rescue
        render plain: 'Bad Request', status: 400
      end
    else
      render plain: 'Not Found', status: 404
    end
  end

private
  def site_params
    params.permit(:title, :url, :published, :site_id)
  end
end
