class AddDateColumnToReviews < ActiveRecord::Migration[7.0]
  def change
    add_column :reviews, :date, :date
  end
end
