class WebsiteController < ApplicationController
  def show
    set_website_data(params[:url])

    if !@site.blank? && @site.published
      render :show
    else
      render json: { message: 'Not Found' }, status: 404
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
      data[:page] = data[:site].try(:page).try(:find_by, slug: slug)
      data[:pages] = data[:site].try(:page).try(:sort_by) { |p| p.order }
      data[:elements] = data[:page].try(:element).try(:sort_by) { |e| e.order }
      data
    end

    @site = cached_data[:site]
    @page = cached_data[:page]
    @pages = cached_data[:pages]
    @elements = cached_data[:elements]
    # Clean up the link so we can use them on anchor tags in layout
    unless @site.blank?
      @domain_link = (@site.url.gsub!('/', '%2F') || @site.url).gsub!(':', '%3A')
    end
  end

end
