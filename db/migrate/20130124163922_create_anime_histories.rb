class CreateAnimeHistories < ActiveRecord::Migration
  def self.up
    create_table :anime_histories do |t|
      t.integer :anime_id
      t.string :title, :null => false
      t.string :kana, :null => false
      t.text :outline
      t.date :started_on
      t.date :finished_on
      t.integer :total_episode
      t.boolean :movie_flg, :null => false, :default => false
      t.boolean :tokusatsu_flg, :null => false, :default => false
      t.integer :status, :default => 1, :null => false
      t.integer :production_id
      t.integer :fastest_weekday
      t.integer :mylist_count, :null => false, :default => 0
      t.integer :user_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :anime_histories
  end
end
