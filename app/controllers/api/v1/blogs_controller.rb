# app/controllers/api/v1/blogs_controller.rb

class Api::V1::BlogsController < BaseController
  before_action :set_blog, only: [:show, :update, :destroy]

  def index
    @blogs = Blog.order(id: :desc)
  end

  def show; end

  def create
    @blog = Blog.new(blog_params.except(:image_data))
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
    if @blog.update(blog_params.except(:image_data))
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

  def read_image_data
    image_data = params[:blog][:image_data]
    if image_data.is_a?(String) && image_data.start_with?('data:image')
      puts "old image exists"
    elsif image_data.is_a?(ActionDispatch::Http::UploadedFile)
      file = params[:blog][:image_data]
      encoded = ::Base64.encode64(File.read(file.path)).delete("\n")
      content_type = file.content_type # Make sure you store the content type
      data_uri = "data:#{content_type};base64,#{encoded}"
      @blog.image_data = data_uri
    else
      # Neither a base64 string nor a file upload.
      # Handle this case as needed.
    end
  end

  def set_blog
    begin
      @blog = Blog.friendly.find(params[:id])
    rescue
      render json: { error: 'Blog not found' }, status: :not_found unless @blog
    end
  end

  def blog_params
    params.require(:blog).permit(:title, :content, :admin_only, :user_id, :image_data, :slug, :meta_title, :meta_desc)
  end

end
