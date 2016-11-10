class CreateMymemories < ActiveRecord::Migration
	def self.up
		create_table :mymemories do |t|
			t.integer :user_id , :null => false
			t.integer :anime_id , :null => false
			t.integer :favorite_flg ,:null => false, :default => 0, :limit => 4
			t.integer :watch_flg ,:null => false, :default => 0, :limit => 4
			t.integer :myfolder_id
			t.string :memo
			t.integer :story_fav_flg, :default => 0
			t.integer :voice_fav_flg, :default => 0
			t.integer :chara_fav_flg, :default => 0
			t.integer :animation_fav_flg, :default => 0
			t.integer :performance_fav_flg, :default => 0
			t.integer :sound_fav_flg
			t.timestamps
		end
		add_index :mymemories, [:user_id, :anime_id]
	end

  def self.down
    drop_table :mymemories
  end
end
