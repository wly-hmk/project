class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  before_action :restrict_content_type, :except => [:show, :index, :delete]

  def not_found
    render json: { message: 'Not Found' }, status: 404
  end

protected
  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      @user = User.find_by(api_token: token)
    end
  end

  def clear_site_cache(site)
    # Need to clear the caches for all the pages for a site
    site.page.each do |page|
      Rails.cache.delete(site.url + '/' + page.slug)
    end
  end

  def restrict_content_type
    allowed_types = ['application/json', 'multipart/form-data']
    unless (allowed_types.include? request.content_type) ||
           request.content_type.blank?
      render json: { message: 'Content-Type must be application/json' },
             status: 415
    end
  end
end
