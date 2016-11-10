class CreateUnits < ActiveRecord::Migration
  def self.up
    create_table :units do |t|
      t.integer :unit_id, :null => false, :default => 0
      t.integer :artist_id, :null => false, :default => 0

    end
  end

  def self.down
    drop_table :units
  end
end
