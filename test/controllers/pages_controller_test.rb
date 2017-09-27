require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.last
    @site = @user.site.first
    @headers = {
       'Authorization': "Token token=#{@user.api_token}",
       'Content-Type': 'application/json'
     }
  end

  test 'should get pages for a site' do
    get "/sites/#{@site.id}/pages", headers: @headers
    assert_same(JSON.parse(@response.body).count, @site.page.count)
  end

  test 'should create a page for a site' do
    post "/sites/#{@site.id}/pages",
         params: {
           name: "hello",
           slug: "hello-page",
           order: 2,
         }.to_json,
         headers: @headers
    assert_equal(@site.page.count, 2)
  end

  test 'should update a page' do
    new_slug = "hello-world"
    page_id = @site.page.first.id
    patch "/sites/#{@site.id}/pages/#{page_id}",
          params: {
            slug: new_slug
          }.to_json,
          headers: @headers
    assert_equal(Page.find(page_id).slug, new_slug)
  end

  test 'should delete a page' do
    page_id = @site.page.first.id
    delete "/sites/#{@site.id}/pages/#{page_id}", headers: @headers
    assert_nil(Page.find_by(id: page_id))
  end
end
