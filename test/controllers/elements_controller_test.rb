require 'test_helper'

class ElementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.last
    @site = @user.site.first
    @page = @site.page.first
    @headers = {
       'Authorization': "Token token=#{@user.api_token}",
       'Content-Type': 'application/json'
     }
  end

  test 'should create an element for a page' do

  end
end
