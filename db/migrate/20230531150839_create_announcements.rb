class CreateAnnouncements < ActiveRecord::Migration[5.2]
  def change
    create_table :announcements do |t|
      t.string :title
      t.text :body
      t.datetime :start_at
      t.datetime :ended_at

      t.timestamps
    end
  end
end
