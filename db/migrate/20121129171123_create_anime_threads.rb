class CreateAnimeThreads < ActiveRecord::Migration
  def self.up
    create_table :anime_threads do |t|
      t.integer :anime_id, :null => false, :default => 0
      t.integer :user_id, :null => false
      t.integer :episode_id, :null => false, :default => 0
      t.string :title, :null => false
      t.integer :total_comment, :null => false, :default => 1
      t.integer :status, :null => false, :default => 1, :limit => 4
      t.integer :favorite_count, :null => false, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :anime_threads
  end
end
