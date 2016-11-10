class CreateEpisodes < ActiveRecord::Migration
  def self.up
    create_table :episodes do |t|
      t.integer :anime_id
      t.integer :episode
      t.string :subtitle
      t.integer :total_watched_count
      t.integer :total_favorite_count
      t.integer :status, :limit => 4

      t.timestamps
    end
  end

  def self.down
    drop_table :episodes
  end
end
