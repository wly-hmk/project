class PagesController < ApplicationController
  before_action :authenticate

  def index
    if current_site
      pages = Page.where(site_id: current_site.id)
      render json: pages, status: 200
    else
      pages = []
      render plain: 'Not Found', status: 404
    end
  end

  def create
    if current_site
      begin
        page = Page.new(page_params)
        page.site = current_site
        page.save!
        render json: page, status: 201
      rescue
        render plain: 'Bad request', status: 400
      end
    else
      render plain: 'Not Found', status: 404
    end
  end

  def update
    if page = @user.page.find(params[:page_id])
      begin
        page.update_attributes(page_params)
        render json: page, status: 200
      rescue
        render plain: 'Bad Request', status: 400
      end
    else
      render plain: 'Not Found', status: 404
    end
  end

private
  def page_params
    params.except(:site_id, :page_id).permit(:name, :slug, :order)
  end

  def current_site
    # Making sure that the site belongs to the user
    @user.site.find(params[:site_id])
  end
end
