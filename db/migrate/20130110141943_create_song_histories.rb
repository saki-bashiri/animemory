class CreateSongHistories < ActiveRecord::Migration
  def self.up
    create_table :song_histories do |t|
      t.integer :song_id, :null => false
      t.integer :anime_id
      t.string :title, :null => false
      t.integer :singer_id
      t.integer :composer_id
      t.integer :songwriter_id
      t.integer :song_type, :limit => 4
      t.string :description, :default => ""
      t.integer :status, :limit => 4
      t.integer :editor_id, :null => false
      t.integer :revision_id, :null => false, :default => 0

      t.timestamps
    end
    
    add_index :song_histories, :song_id
    add_index :song_histories, :editor_id
    add_index :song_histories, :revision_id
  end

  def self.down
    drop_table :song_histories
  end
end
