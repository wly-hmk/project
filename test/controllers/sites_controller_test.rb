require 'test_helper'

class SitesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.last
    @headers = {
       'Authorization': "Token token=#{@user.api_token}",
       'Content-Type': 'application/json'
     }
  end

  test "should get list of sites for user" do
    get '/sites', headers: @headers
    assert_same(JSON.parse(@response.body).count, @user.site.count)
  end

  test "should create a site for user" do
    original_sites = @user.site.count
    post '/sites',
         params: {
           title: "hello",
           url: "http://www.example.com",
           published: true,
         }.to_json,
         headers: @headers
    get '/sites', headers: { 'Authorization': "Token token=#{@user.api_token}"}
    assert_same(JSON.parse(@response.body).count, 2)
  end

  test "should update a site for user" do
    site_id = Site.last.id
    new_title = "hello world"
    patch "/sites/#{site_id}",
          params: {
            title: new_title
          }.to_json,
          headers: @headers
    assert_equal(Site.find(site_id).title, new_title)
  end

  test "should delete a site for user" do
    site_id = Site.last.id
    delete "/sites/#{site_id}", headers: @headers
    assert_nil(Site.find_by(id: site_id))
  end

end
