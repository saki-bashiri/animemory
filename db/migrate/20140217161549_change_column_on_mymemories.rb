class ChangeColumnOnMymemories < ActiveRecord::Migration
  def up
    add_column :mymemories, :watch_status, :integer, :null => false, :default => 0, :after => :favorite_flg
    remove_column :mymemories, :watch_flg
    change_column :mymemories, :favorite_flg, :boolean, :null => false, :default => 0
    add_index :mymemories, :anime_id, :name => "anime_id"
  end

  def down
    remove_column :mymemories, :watch_status
  end
end
