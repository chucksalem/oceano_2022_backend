class AddImageDataToBlogs < ActiveRecord::Migration[7.0]
  def change
    add_column :blogs, :image_data, :binary
  end
end
