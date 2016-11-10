class AddIndexViewTables < ActiveRecord::Migration
  def up
    add_index :summaries, :created_at, :name => "created_at"
    add_index :outside_sites, :status, :name => "status"
    add_index :outside_summaries, :outside_site_id, :name => "outside_site_id"
    add_index :tag_groups, :tag_id, :name => "tag_id"
    add_index :episodes, :anime_id, :name => "anime_id"
    add_index :episodes, :status, :name => "status"
  end

  def down
  end
end
