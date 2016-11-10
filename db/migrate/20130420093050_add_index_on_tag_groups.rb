class AddIndexOnTagGroups < ActiveRecord::Migration
  def up
    add_index :tag_groups, [:anime_id, :tag_id], :unique => true, :name => "unique_anime_tag"
  end

  def down
    remove_index :tag_groups, :name => "unique_anime_tag"
  end
end
