class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

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
end
