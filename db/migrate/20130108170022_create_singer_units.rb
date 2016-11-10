class CreateSingerUnits < ActiveRecord::Migration
  def self.up
    create_table :singer_units do |t|
      t.integer :unit_id
      t.integer :singer_id

      t.timestamps
    end
    
    add_index :singer_units, :unit_id
    add_index :singer_units, :singer_id
  end

  def self.down
    drop_table :singer_units
  end
end
