module Admin
  class BlogsController < Admin::ApplicationController
    # include ActiveStorage::SetCurrent
    # before_action :set_blog, only: [:edit, :update, :destroy, :show]
    # Overwrite any of the RESTful controller actions to implement custom behavior
    # For example, you may want to send an email after a foo is updated.

    def create
      # Build a new Blog object using strong parameters
      @blog = resource_class.new(resource_params.except(:image_data))

      read_image_data

      if @blog.save
        redirect_to [:admin, @blog], notice: "Blog was successfully created."
      else
        render :new, locals: { page: Administrate::Page::Form.new(dashboard, @blog) }
      end
    end
    def update
      # Build a new Blog object using strong parameters
      @blog = resource_class.friendly.find(params[:id])
      read_image_data

      if @blog.update(resource_params.except(:image_data))
        redirect_to [:admin, @blog], notice: "Blog was successfully updated."
      else
        render :edit, locals: { page: Administrate::Page::Form.edit(dashboard, @blog) }
      end
    end

    # Override this method to specify custom lookup behavior.
    # This will be used to set the resource for the `show`, `edit`, and `update`
    # actions.
    #
    # def find_resource(param)
    #   Foo.find_by!(slug: param)
    # end

    # The result of this lookup will be available as `requested_resource`

    # Override this if you have certain roles that require a subset
    # this will be used to set the records shown on the `index` action.
    #
    # def scoped_resource
    #   if current_user.super_admin?
    #     resource_class
    #   else
    #     resource_class.with_less_stuff
    #   end
    # end

    # Override `resource_params` if you want to transform the submitted
    # data before it's persisted. For example, the following would turn all
    # empty values into nil values. It uses other APIs such as `resource_class`
    # and `dashboard`:
    #

    # def set_blog
    #   @blog = Blog.friendly.find(params[:id])
    #   render json: { error: 'Blog not found' }, status: :not_found unless @blog
    # end

    def resource_params
      params.require(:blog).permit(:title, :content, :admin_only, :user_id, :image_data, :slug, :meta_title, :meta_desc)
    end

    def find_resource(param)
      Blog.friendly.find(params[:id])
    end

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


    # def resource_params
    #   params.require(resource_class.model_name.param_key).
    #     permit(dashboard.permitted_attributes(action_name)).
    #     transform_values { |value| value == "" ? nil : value }
    # end

    # See https://administrate-demo.herokuapp.com/customizing_controller_actions
    # for more information

  end
end
