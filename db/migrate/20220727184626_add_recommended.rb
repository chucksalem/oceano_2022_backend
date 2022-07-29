class AddRecommended < ActiveRecord::Migration[5.2]
  def change
    create_table :recommendeds do |t|
      t.string :unit_id
    end
  end
end
