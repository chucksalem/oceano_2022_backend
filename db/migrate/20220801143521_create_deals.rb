# frozen_string_literal: true

class CreateDeals < ActiveRecord::Migration[5.2]
  def change
    create_table :deals do |t|
      t.string :unit_id
      t.string :text
    end
  end
end
