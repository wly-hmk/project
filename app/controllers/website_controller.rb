class WebsiteController < ApplicationController
  def show
    set_website_data(params[:url])

    if @site.published
      render :show
    else
      render plain: 'Not Found', status: 404
    end
  end

private
  def set_website_data(url)
    uri = URI.parse url
    slug = uri.path
    domain = url[0...-slug.length]
    slug[0] =''

    cached_data = Rails.cache.fetch(url, expires_in: 10.minutes) do
      data = {}
      data[:site] = Site.find_by(url: domain)
      data[:page] = data[:site].page.find_by(slug: slug)
      data[:pages] = data[:site].page.sort_by { |p| p.order }
      data[:elements] = data[:page].element.sort_by { |e| e.order }
      data
    end

    @site = cached_data[:site]
    @page = cached_data[:page]
    @pages = cached_data[:pages]
    @elements = cached_data[:elements]
  end

end
