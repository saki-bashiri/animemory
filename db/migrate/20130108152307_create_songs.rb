class CreateSongs < ActiveRecord::Migration
  def self.up
    create_table :songs do |t|
      t.integer :anime_id
      t.string :title, :null => false
      t.integer :singer_id
      t.integer :composer_id
      t.integer :songwriter_id
      t.integer :song_type, :limit => 4
      t.string :description, :default => ""
      t.integer :status, :limit => 4

      t.timestamps
    end
    
    add_index :songs, :anime_id
    add_index :songs, :singer_id
    add_index :songs, :composer_id
    add_index :songs, :songwriter_id
  end

  def self.down
    drop_table :songs
  end
end
