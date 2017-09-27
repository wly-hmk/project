class ElementsController < ApplicationController
  before_action :authenticate

  def create
    if current_page
      begin
        element = Element.new(element_params)
        element.page = current_page
        element.save!
        clear_site_cache(current_page.site)
        render json: element, status: 201
      rescue
        message = element.errors.full_messages.first.to_s.presence
        render json: { message: message }, status: 400
      end
    else
      render json: { message: 'Not Found' }, status: 404
    end
  end

  def update
    if (element = @user.element.find_by(page_id: params[:page_id],
                                       id: params[:element_id])) &&
                 current_page.site_id == params[:site_id].to_i
      begin
        element.update_attributes(element_params)
        clear_site_cache(current_page.site)
        render json: element, status: 200
      rescue
        message = page.errors.full_messages.first.to_s.presence
        render json: { message: message }, status: 400
      end
    else
      render json: { message: 'Not Found' }, status: 404
    end
  end

  def delete
    if (element = @user.element.find_by(page_id: params[:page_id],
                                       id: params[:element_id])) &&
                 current_page.site_id == params[:site_id].to_i
      element.destroy
      clear_site_cache(current_page.site)
      head :no_content
    else
      render json: { message: 'Not Found' }, status: 404
    end
  end


private
  def element_params
    params.except(:page_id, :element_id, :site_id)
      .permit(:element, :element_attributes, :content, :order)
  end

  def current_page
    # Making sure current belongs to user
    @user.page.find(params[:page_id])
  end
end
