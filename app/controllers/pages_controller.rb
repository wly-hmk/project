class PagesController < ApplicationController
  before_action :authenticate

  def index
    if current_site
      site_id = current_site.id
      pages = Rails.cache.fetch("site_#{site_id}_pages", expires_in: 1.hour) do
        Page.where(site_id: current_site.id)
      end
      render json: pages, status: 200
    else
      pages = []
      render json: { message: 'Not Found' }, status: 404
    end
  end

  def create
    if current_site
      begin
        page = Page.new(page_params)
        page.site = current_site
        page.save!
        delete_site_pages_cache
        clear_site_cache(current_site)
        render json: page, status: 201
      rescue
        message = page.errors.full_messages.first.to_s
        render json: { message: message }, status: 400
      end
    else
      render json: { message: 'Not Found' }, status: 404
    end
  end

  def update
    if page = @user.page.find_by(id: params[:page_id],
                                 site_id: params[:site_id])
      begin
        page.assign_attributes(page_params)
        page.save!
        clear_site_cache(current_site)
        delete_site_pages_cache
        render json: page, status: 200
      rescue
        message = page.errors.full_messages.first.to_s.presence
        render json: { message: message }, status: 400
      end
    else
      render json: { message: 'Not Found' }, status: 404
    end
  end

  def delete
    if page = @user.page.find_by(id: params[:page_id],
                                 site_id: params[:site_id])
      clear_site_cache(current_site)
      page.destroy
      delete_site_pages_cache
      head :no_content
    else
      render json: { message: 'Not Found' }, status: 404
    end
  end

private
  def page_params
    params.except(:site_id, :page_id).permit(:name, :slug, :order)
  end

  def current_site
    # Making sure that the site belongs to the user
    @user.site.find_by(id: params[:site_id])
  end

  def delete_site_pages_cache
    Rails.cache.delete("site_#{current_site.id}_pages")
  end
end
