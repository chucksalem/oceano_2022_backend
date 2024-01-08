# app/controllers/admin/blogs_controller.rb

class Admin::BlogsController < BaseController
  include ActiveStorage::SetCurrent
  before_action :authenticate_admin
  before_action :set_blog, only: [:edit, :update, :destroy, :show]

  def index
    @blogs = Blog.order(id: :desc)
  end

  def show; end

  def new
    @blog = Blog.new
  end

  def create
    @blog = Blog.new(blog_params)
    read_image_data

    if @blog.save
      render json: { message: 'Blog created successfully.' }, status: :created
    else
      render json: { errors: @blog.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def edit
    @blog = Blog.find(params[:id])
    render json: @blog
  end

  def update
    read_image_data
    if @blog.update(blog_params)
      render json: { message: 'Blog updated successfully.' }
    else
      render json: { errors: @blog.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @blog.destroy
    render json: { message: 'Blog deleted successfully.' }
  rescue StandardError => e
    render json: { error: 'Failed to delete blog', details: e.message }, status: :unprocessable_entity

  end

  private

  def set_blog
    @blog = Blog.find_by_id(params[:id])
    render json: { error: 'Blog not found' }, status: :not_found unless @blog
  end

  def blog_params
    params.require(:blog).permit(:title, :content).merge(admin_only: true, user_id: current_user.id)
  end

  def authenticate_admin
    authenticate_user!
  rescue StandardError => e
    render json: { error: 'Authentication failed', details: e.message }, status: :unauthorized
  end
  
  def read_image_data
    @blog.image_data = params[:image].read if params[:image]
  end
end
