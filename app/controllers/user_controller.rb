class UserController < ApplicationController
  def index
    @user_signedup = cookies[:signed_in]
  end

  def create
    user = User.new(user_params)
    begin
      user.save!
      cookies[:signed_in] = true
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
