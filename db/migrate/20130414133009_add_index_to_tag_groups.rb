class AddIndexToTagGroups < ActiveRecord::Migration
  def change
    add_index :tag_groups, :anime_id, :name => "anime_id"
    add_index :tag_groups, :tag_id, :name => "tag_id"
  end
end
