class RenameGroupIdToAwardGroupId < ActiveRecord::Migration
  def change
    rename_column :sows, :group_id, :award_group_id
  end
end
