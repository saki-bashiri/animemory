class CreateSongWriters < ActiveRecord::Migration
  def up
    create_table :song_artists do |t|
      t.integer :song_id, :null => false
      t.integer :artist_id, :null => false
      t.integer :song_artist_type, :null => false
      t.integer :artist_sort, :null => false, :default => 0
    end

    add_index :song_artists, [:song_id, :song_artist_type, :artist_id], :name => "song_artist", :unique => true
    add_index :song_artists, :artist_id, :name => "artist_id"
    add_index :song_artists, :song_artist_type, :name => "song_artist_type"
    add_index :song_artists, [:song_id, :song_artist_type, :artist_sort], :name => "song_artist_sort"
    remove_column :songs, :singer_id
    remove_column :songs, :songwriter_id
    remove_column :songs, :composer_id
    remove_column :songs, :arranger_id

    add_column :units, :unit_sort, :integer, :null => false, :default => 0, :after => :artist_id
  end

  def down
  end
end
