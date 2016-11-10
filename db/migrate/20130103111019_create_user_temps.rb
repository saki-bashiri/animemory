class CreateUserTemps < ActiveRecord::Migration
  def self.up
    create_table :user_temps do |t|
      t.string :mail_address, :null => false
      t.string :token, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :user_temps
  end
end
