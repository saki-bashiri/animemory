class AddColumnProfileImagePathToUsers < ActiveRecord::Migration
  def up
    add_column :users, :profile_image_url, :string, :after => :twitter_cd
    add_column :users, :profile_background_image_url, :string, :after => :profile_image_url
    change_column :users, :twitter_cd, :integer, :null => false, :default => 0, :limit => 8, :after => :register_type
    remove_column :users, :mail_address
    remove_column :users, :password
    drop_table :user_temps
  end

  def down

  end
end
