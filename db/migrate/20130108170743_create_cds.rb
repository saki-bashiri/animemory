class CreateCds < ActiveRecord::Migration
  def self.up
    create_table :cds do |t|
      t.string :title, :null => false
      t.integer :song_id
      t.integer :anime_id
      t.date :released_on

      t.timestamps
    end
    
    add_index :cds, :song_id
    add_index :cds, :anime_id
  end

  def self.down
    drop_table :cds
  end
end
