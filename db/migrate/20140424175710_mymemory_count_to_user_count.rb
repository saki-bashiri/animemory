class MymemoryCountToUserCount < ActiveRecord::Migration
  def up
    add_column :user_counts, :favorite_count, :integer, :null => false, :default => 0, :after => :user_id
    add_column :user_counts, :watching_count, :integer, :null => false, :default => 0, :after => :favorite_count
    add_column :user_counts, :watched_count,  :integer, :null => false, :default => 0, :after => :watching_count
  end

  def down
  end
end
