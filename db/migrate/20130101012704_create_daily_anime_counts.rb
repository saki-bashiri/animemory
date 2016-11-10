class CreateDailyAnimeCounts < ActiveRecord::Migration
  def self.up
    create_table :daily_anime_counts do |t|
			t.integer :anime_id, :null => false
			t.date :day, :null => false
			t.integer :favorite_count, :null => false, :default => 0
			t.integer :watch_count, :null => false, :default => 0
			t.integer :comment_count, :null => false, :default => 0
			t.integer :pv_count, :null => false, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :daily_anime_counts
  end
end
