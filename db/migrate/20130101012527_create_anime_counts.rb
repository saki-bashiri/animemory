class CreateAnimeCounts < ActiveRecord::Migration
  def self.up
    create_table :anime_counts do |t|
			t.integer :anime_id, :null => false
			t.integer :favorite_count, :null => false
			t.integer :watch_count, :null => false, :default => 0
			t.integer :comment_count, :null => false, :default => 0
			t.integer :total_pv_count, :null => false, :default => 0
			t.integer :story_fav_count, :null => false, :default => 0
			t.integer :voice_fav_count, :null => false, :default => 0
			t.integer :chara_fav_count, :null => false, :default => 0
			t.integer :animation_fav_count, :null => false, :default => 0
			t.integer :performance_fav_count, :null => false, :default => 0
			t.integer :sound_fav_count, :null => false, :default => 0
      t.timestamps
    end
		add_index :anime_counts, :anime_id
  end

  def self.down
    drop_table :anime_counts
  end
end
