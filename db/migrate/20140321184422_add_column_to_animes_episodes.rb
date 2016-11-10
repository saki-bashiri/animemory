class AddColumnToAnimesEpisodes < ActiveRecord::Migration
  def change
    create_table :anime_scores do |t|
      t.integer :anime_id, :null => false
      t.integer :favorite_count, :null => false, :default => 0
      t.integer :watching_count, :null => false, :default => 0
      t.integer :watched_count, :null => false, :default => 0
      t.timestamps
    end

    add_index :anime_scores, :anime_id, :unique => true
    add_index :anime_scores, :favorite_count
    add_index :anime_scores, :watching_count
    add_index :anime_scores, :watched_count
    add_column :episodes, :watched_count, :integer, :null => false, :default => 0
  end
end
