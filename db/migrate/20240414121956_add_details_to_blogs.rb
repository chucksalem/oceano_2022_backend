class AddDetailsToBlogs < ActiveRecord::Migration[7.0]
  def change
    add_column :blogs, :slug, :string
    add_column :blogs, :meta_desc, :text
    add_column :blogs, :meta_title, :string
  end
end
