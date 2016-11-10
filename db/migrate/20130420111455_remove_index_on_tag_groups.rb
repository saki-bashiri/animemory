class RemoveIndexOnTagGroups < ActiveRecord::Migration
  def up
    remove_index :tag_groups, :name => "tag_id"
    remove_index :tag_groups, :name => "anime_id"
  end

  def down
  end
end
