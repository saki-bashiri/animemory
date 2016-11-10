class AddColumnAdminFlgToUsers < ActiveRecord::Migration
  def up
    add_column :users, :admin_status, :integer, :default => 0, :null => false, :after => :status
    change_column :users, :twitter_cd, :integer, :default => 0, :null => false, :after => :register_type

    add_index :users, :admin_status, :name => "admin_status"
  end

  def down
    remove_column :users, :admin_status
  end
end
