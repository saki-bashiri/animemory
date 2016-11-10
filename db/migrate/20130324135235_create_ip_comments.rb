class CreateIpComments < ActiveRecord::Migration
  def change
    create_table :ip_comments do |t|
      t.integer :episode_id, :null => false
      t.integer :anime_id, :null => false
      t.string :ip_address, :null => false
      t.text :content, :null => false
      t.timestamps
    end
    
    add_index :ip_comments, :episode_id, :unique => true
    add_index :ip_comments, :anime_id, :unique => true
    add_index :ip_comments, :ip_address
  end
end
