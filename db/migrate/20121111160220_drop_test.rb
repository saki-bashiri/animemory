class DropTest < ActiveRecord::Migration
  def self.up
   drop_table :tests
  end

  def self.down
  end
end
