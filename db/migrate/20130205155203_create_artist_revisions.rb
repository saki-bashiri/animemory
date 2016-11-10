class CreateArtistRevisions < ActiveRecord::Migration
  def self.up
    create_table :artist_revisions do |t|
      t.integer :artist_id, :null => false, :default => 0
      t.string :name, :null => false, :default => ""
      t.string :kana, :null => false, :default => ""
      t.string :nickname, :default => ""
      t.datetime :birthday
      t.string :description, :default => ""
      t.integer :unit_flg, :null => false, :default => 0
      t.integer :voice_actor_id, :null => false, :default => 0
      t.integer :office_id, :null => false, :default => 0
      t.integer :record_office_id, :null => false, :default => 0
      t.integer :singer_flg, :null => false, :default => 0
      t.integer :composer_flg, :null => false, :default => 0
      t.integer :songwriter_flg, :null => false, :default => 0
      t.integer :user_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :artist_revisions
  end
end
