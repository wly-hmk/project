class SitesController < ApplicationController
  before_action :authenticate

  def index
    sites = Rails.cache.fetch("user_#{@user.id}_sites", expires_in: 1.hour) do
      Site.where(user: @user)
    end
    render json: sites, status: 200
  end

  def show
    site = Rails.cache.fetch("site_#{params[:site_id]}", expires_in: 1.hour) do
      Site.find_by(id: params[:site_id], user_id: @user.id)
    end
    if site.nil?
      render json: { message: 'Not Found'}, status: 404
    else
      render json: site, status: 200
    end
  end

  def create
    site = Site.new(site_params)
    site.user = @user
    begin
      site.save!
      delete_user_sites_cache
      render json: site, status: 201
    rescue
      message = site.errors.full_messages.first.to_s
      render json: { message: message }, status: 400
    end
  end

  def update
    if site = @user.site.find_by(id: params[:site_id])
      begin
        site.assign_attributes(site_params)
        site.save!
        clear_site_cache(site)
        delete_user_sites_cache
        render json: site, status: 200
      rescue
        message = site.errors.full_messages.first.to_s
        render json: { message: message }, status: 400
      end
    else
      render json: { message: 'Not Found'}, status: 404
    end
  end

  def delete
    if site = @user.site.find_by(id: params[:site_id])
      clear_site_cache(site)
      site.destroy
      delete_user_sites_cache
      head :no_content
    else
      render json: { message: 'Not Found'}, status: 404
    end
  end

private
  def site_params
    params.except(:site_id).permit(:title, :url, :published)
  end

  def delete_user_sites_cache
    Rails.cache.delete("user_#{@user.id}_sites")
  end
end
