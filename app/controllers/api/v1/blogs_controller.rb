# app/controllers/api/v1/blogs_controller.rb

class Api::V1::BlogsController < BaseController
  before_action :set_blog, only: [:show]

  def index
    @blogs = Blog.all
    render json: @blogs
  end

  def show
    render json: @blog
  end

  private

  def set_blog
    @blog = Blog.find(params[:id])
  end
end
