class CreateSingers < ActiveRecord::Migration
  def self.up
    create_table :singers do |t|
      t.string :name, :null => false
      t.string :kana, :null => false
      t.string :nickname, :default => ""
      t.string :description, :default => ""
      t.integer :unit_flg, :limit => 4
      t.integer :voice_actor_id
      t.integer :office_id
      t.integer :record_office_id

      t.timestamps
    end
    
    add_index :singers, :voice_actor_id
    add_index :singers, :office_id
    add_index :singers, :record_office_id
  end

  def self.down
    drop_table :singers
  end
end
