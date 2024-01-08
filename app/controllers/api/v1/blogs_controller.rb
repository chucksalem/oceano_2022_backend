# app/controllers/api/v1/blogs_controller.rb

class Api::V1::BlogsController < BaseController
  include ActiveStorage::SetCurrent
  before_action :set_blog, only: [:show]

  def index
    @blogs = Blog.order(id: :desc)
  end

  def show; end

  private

  def set_blog
    @blog = Blog.find_by_id(params[:id])
    render json: { error: 'Blog not found' }, status: :not_found unless @blog
  end
end
