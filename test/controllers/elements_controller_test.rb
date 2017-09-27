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
    post "/sites/#{@site.id}/pages/#{@page.id}/elements",
         params: {
           element: "p",
           element_attributes: "{}",
           order: 2,
           content: 'Hello world!',
         }.to_json,
         headers: @headers
    assert_equal(@page.element.count, 2)
  end

  test 'should update an element' do
    new_content = "A quick brown fox jumped."
    element_id = @page.element.first.id
    patch "/sites/#{@site.id}/pages/#{@page.id}/elements/#{element_id}",
          params: {
            content: new_content
          }.to_json,
          headers: @headers
    assert_equal(Element.find(element_id).content, new_content)
  end

  test 'should delete an element' do
    element_id = @page.element.first.id
    delete "/sites/#{@site.id}/pages/#{@page.id}/elements/#{element_id}", headers: @headers
    assert_nil(Element.find_by(id: element_id))
  end
end
