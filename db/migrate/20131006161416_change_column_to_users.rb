class ChangeColumnToUsers < ActiveRecord::Migration
  def up
    add_column :users, :twitter_cd, :integer
    change_column :users, :mail_address, :string, :null => true
    change_column :users, :password, :string, :null => true
    remove_column :users, :salt
    remove_index :users, :name => "unique_index_mail_address"
  end

  def down
  end
end
