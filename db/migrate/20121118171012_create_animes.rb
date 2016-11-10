class CreateAnimes < ActiveRecord::Migration
  def self.up
    create_table :animes do |t|
      t.string :title, :null => false
      t.string :kana, :null => false
      t.text :outline, :limit => 1000
      t.date :started_on
      t.date :finished_on
      t.integer :total_episode, :limnit => 4
      t.boolean :movie_flg, :null => false, :default => 0
      t.boolean :tokusatsu_flg, :null => false, :default => 0
      t.integer :status, :null => false, :default => 1, :limit => 4
      t.integer :production_id
      t.integer :fastest_weekday, :limit => 4
      t.integer :mylist_count, :null => false, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :animes
  end
end
