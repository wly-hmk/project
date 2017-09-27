require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.last
    @site = Site.last
    @headers = {
       'Authorization': "Token token=#{@user.api_token}",
       'Content-Type': 'application/json'
     }
  end

end
