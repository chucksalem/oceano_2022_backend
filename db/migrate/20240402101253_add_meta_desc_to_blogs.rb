class AddMetaDescToBlogs < ActiveRecord::Migration[7.0]
  def change
    add_column :blogs, :meta_desc, :string
    add_column :blogs, :meta_title, :string
  end
end
