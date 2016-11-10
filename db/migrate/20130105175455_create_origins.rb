class CreateOrigins < ActiveRecord::Migration
  def self.up
    create_table :origins do |t|
      t.string :title, :null => false
      t.integer :original_type, :null => false, :default => 0
      t.string :description
      t.integer :status, :null => false, :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :origins
  end
end
