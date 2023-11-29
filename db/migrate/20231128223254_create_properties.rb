class CreateProperties < ActiveRecord::Migration[7.0]
  def change
    create_table :properties do |t|
      t.string :name
      t.string :address
      t.text :amenities
      t.integer :bathrooms
      t.integer :bedrooms
      t.string :code
      t.text :descriptions
      t.integer :num_floors
      t.integer :occupancy
      t.text :position
      t.string :type
      t.text :reviews
      t.boolean :beachfront
      t.boolean :pets

      t.timestamps
    end
  end
end
