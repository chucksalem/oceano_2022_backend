class AddTextToRecommendations < ActiveRecord::Migration[5.2]
  def change
    add_column :recommendations, :text, :string
  end
end
