class FixBlogTitleImages < ActiveRecord::Migration[7.0]
  def up
    Blog.all.each do |blog|
      if blog.image_data.present?
        str = blog.image_data
        unless  str.is_a?(String) && str.length >10 && str.include?('data:image')
          encoded = ::Base64.encode64(blog.image_data).delete("\n")
          content_type = 'png' # Make sure you store the content type
          data_uri = "data:#{content_type};base64,#{encoded}"
          blog.image_data = data_uri
          blog.save
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end
