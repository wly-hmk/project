class SitesController < ApplicationController
  before_action :authenticate

  def index
    sites = Rails.cache.fetch("user_#{@user.id}_sites", expires_in: 1.hour) do
      Site.where(user: @user)
    end
    render json: sites, status: 200
  end

  def create
    site = Site.new(site_params)
    site.user = @user
    begin
      site.save!
      delete_user_sites_cache
      render json: site, status: 201
    rescue
      render plain: 'Bad Request', status: 400
    end
  end

  def update
    if site = @user.site.find_by(id: params[:site_id])
      begin
        params_copy = site_params
        params_copy.delete :site_id
        site.update_attributes(params_copy)
        clear_site_cache(site)
        delete_user_sites_cache
        render json: site, status: 200
      rescue
        render plain: 'Bad Request', status: 400
      end
    else
      render plain: 'Not Found', status: 404
    end
  end

  def delete
    if site = @user.site.find_by(id: params[:site_id])
      clear_site_cache(site)
      site.destroy
      delete_user_sites_cache
      head :no_content
    else
      render plain: 'Not Found', status: 404
    end
  end

private
  def site_params
    params.permit(:title, :url, :published, :site_id)
  end

  def delete_user_sites_cache
    Rails.cache.delete("user_#{@user.id}_sites")
  end
end
