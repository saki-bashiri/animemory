class CreateProductions < ActiveRecord::Migration
  def self.up
    create_table :productions do |t|
      t.string :name, :null => false, :default => ""
      t.string :kana, :null => false, :default => ""
      t.string :description, :default => ""
      t.integer :status, :null => false, :default => 0, :limit => 4

      t.timestamps
    end
  end

  def self.down
    drop_table :productions
  end
end
