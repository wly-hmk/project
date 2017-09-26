class UserController < ApplicationController
  skip_before_action :restrict_content_type

  def index
    @user_signedup = cookies[:signed_in]
    @api_token = cookies[:api_token]
  end

  def create
    user = User.new(user_params)
    begin
      user.save!
      cookies[:signed_in] = true
      cookies[:api_token] = user.api_token
      redirect_back(fallback_location: '')
    rescue
      flash[:notice] = "Please fill out all the fields"
      redirect_back(fallback_location: '')
    end
  end

private
  def user_params
    params.permit(:name, :password, :email)
  end
end
