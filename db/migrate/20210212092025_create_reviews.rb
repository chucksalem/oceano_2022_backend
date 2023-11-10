# frozen_string_literal: true

class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.string :first_name
      t.string :last_name
      t.string :unit_id
      t.text :comment
      t.integer :stars

      t.timestamps
    end
  end
end
