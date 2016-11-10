class CreateCharacters < ActiveRecord::Migration
  def self.up
    create_table :characters do |t|
      t.integer :anime_id, :null => false
      t.integer :voice_actor_id, :null => false
      t.string :name, :null => false
      t.string :kana
      t.string :comment
      t.integer :status, :null => false, :default => 1

      t.timestamps
    end
    
    add_index :characters, :anime_id
    add_index :characters, :voice_actor_id
  end

  def self.down
    drop_table :characters
  end
end
