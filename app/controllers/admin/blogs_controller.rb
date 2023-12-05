# app/controllers/admin/blogs_controller.rb

class Admin::BlogsController < BaseController
  include ActiveStorage::SetCurrent
  before_action :authenticate_admin
  before_action :set_blog, only: [:edit, :update, :destroy, :show]

  def index
    @blogs = Blog.all
    render json: @blogs
  end

  def show
    render json: @blog
  end

  def new
    @blog = Blog.new
  end

  def create
    @blog = Blog.new(blog_params.merge(admin_only: true, user_id: 1))
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
    if @blog.update(blog_params)
      render json: { message: 'Blog updated successfully.' }
    else
      render json: { errors: @blog.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @blog.destroy
    render json: { message: 'Blog deleted successfully.' }
  end

  private

  def set_blog
    @blog = Blog.find(params[:id])
  end

  def blog_params
    params.require(:blog).permit(:title, :content, :title_image, images: [])
  end

  def authenticate_admin
    authenticate_user!
  end
end
