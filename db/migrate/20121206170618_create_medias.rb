class CreateMedias < ActiveRecord::Migration
  def self.up
    create_table :medias do |t|
      t.string :name, :null => false
      t.string :other_name
      t.integer :media_type, :null => false, :limit => 4
      t.string :hp_url

      t.timestamps
    end
    add_index :medias, :name
  end

  def self.down
    drop_table :medias
  end
end
