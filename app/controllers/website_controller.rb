class WebsiteController < ApplicationController
  def show
    url = params[:url]
    uri = URI.parse url

    slug = uri.path
    domain = url[0...-slug.length]
    slug[0] =''

    @site = Site.find_by(url: domain)
    if @site.published
      @page = @site.page.find_by(slug: slug)

      @pages = @site.page.sort_by { |p| p.order }
      @elements = @page.element.sort_by { |e| e.order }
      render :show
    else
      render plain: 'Not Found', status: 404
    end
  end

end
