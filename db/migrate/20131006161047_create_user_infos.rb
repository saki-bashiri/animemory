class CreateUserInfos < ActiveRecord::Migration
  def change
    create_table :user_infos do |t|
      t.integer :user_id, :null => false
      t.string :mail_address, :null => false, :limit => 200
      t.string :password, :null => false, :limit => 20
      t.timestamps
    end

    add_index :user_infos, :user_id, :name => "user_id", :unique => true
    add_index :user_infos, :mail_address, :name => "mail_address", :unique => true
  end
end
