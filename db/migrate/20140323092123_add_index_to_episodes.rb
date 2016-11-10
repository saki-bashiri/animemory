class AddIndexToEpisodes < ActiveRecord::Migration
  def change
    change_column :episodes, :watched_count, :integer, :null => false, :default => 0, :after => :subtitle
    add_index :episodes, :episode, :name => "episode"
    add_index :episodes, :watched_count, :name => "watched_count"
    remove_column :episodes, :total_watched_count
    remove_column :episodes, :total_favorite_count
  end
end
