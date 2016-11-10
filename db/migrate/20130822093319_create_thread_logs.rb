class CreateThreadLogs < ActiveRecord::Migration
  def change
    create_table :thread_logs do |t|
      t.integer :board_id, :null => false
      t.integer :dat_cd, :null => false
      t.string :subject, :null => false, :limit => 255
      t.integer :count, :null => false, :default => 0
      t.integer :anime_id
      t.boolean :drop_flg, :null => false, :default => 0
      t.timestamps
    end

    add_index :thread_logs, :dat_cd, :name => "dat_cd", :unique => true
    add_index :thread_logs, :anime_id, :name => "anime_id"
  end
end
