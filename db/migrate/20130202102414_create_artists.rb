class CreateArtists < ActiveRecord::Migration
  def self.up
    create_table :artists do |t|
      t.string :name, :null => false
      t.string :kana, :null => false
      t.string :nickname
      t.datetime :birthday
      t.string :description
      t.integer :unit_flg, :null => false, :default => 0, :limit => 4
      t.integer :voice_actor_id, :null => false, :default => 0
      t.integer :office_id, :null => false, :default => 0
      t.integer :record_office_id, :null => false, :default => 0
      t.integer :singer_flg, :null => false, :default => 0, :limit => 4
      t.integer :composer_flg, :null => false, :default => 0, :limit => 4
      t.integer :songwriter_flg, :null => false, :default => 0, :limit => 4
      t.timestamps
    end
  end

  def self.down
    drop_table :artists
  end
end
