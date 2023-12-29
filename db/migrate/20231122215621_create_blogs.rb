class CreateBlogs < ActiveRecord::Migration[7.0]
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :content
      t.boolean :admin_only, default: false  # Added to differentiate admin and regular blogs
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
