class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :anime_id, :null => false
      t.integer :user_id, :null => false
      t.integer :anime_thread_id, :null => false, :default => 0
      t.text :comment, :null => false
      t.integer :status, :null => false, :default => 1, :limit => 4
      t.integer :favorite_count, :null => false, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
