class RenameRecommend < ActiveRecord::Migration[5.2]
  def change
    rename_table :recommendeds, :recommendations
  end
end
