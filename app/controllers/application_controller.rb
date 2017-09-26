class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

protected
  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      @user = User.find_by(api_token: token)
    end
  end
end
