class CreateCharacterRevisions < ActiveRecord::Migration
  def self.up
    create_table :character_revisions do |t|
      t.integer :character_id, :null => false, :default => 0
      t.integer :anime_id, :null => false, :default => 0
      t.integer :artist_id, :default => 0
      t.string :name, :null => false, :default => ""
      t.string :kana, :null => false, :default => ""
      t.string :comment, :null => false, :default => ""
      t.integer :status, :null => false, :default => 1, :limit => 4

      t.timestamps
    end
  end

  def self.down
    drop_table :character_revisions
  end
end
