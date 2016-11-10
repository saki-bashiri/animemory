class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :mail_address, :null => false
      t.string :password, :null => false
      t.string :nickname, :null => false
      t.integer :register_type, :null => false, :limit => 4
      t.integer :status, :null => false, :limit => 4

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
