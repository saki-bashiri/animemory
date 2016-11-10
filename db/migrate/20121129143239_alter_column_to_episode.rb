class AlterColumnToEpisode < ActiveRecord::Migration
  def self.up
    change_column :episodes, :total_favorite_count, :integer, :null => false, :default => 0
    change_column :episodes, :total_watched_count, :integer, :null => false, :default => 0
    change_column :episodes, :status, :integer, :null => false, :default => 1, :limit => 4
    change_column :episodes, :anime_id, :integer, :null => false, :default => 0
  end
  
  def self.down
  end
end
