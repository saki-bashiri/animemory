class CreateAnimeMainImageRevisions < ActiveRecord::Migration
  def change
    create_table :anime_main_image_revisions do |t|
      t.integer :anime_image_id, :null => false, :default => 0
      t.integer :anime_history_id, :null => false, :default => 0

      t.timestamps
    end

    add_index :anime_main_image_revisions, :anime_image_id, :name => "anime_image_id"
    add_index :anime_main_image_revisions, :anime_history_id, :name => "anime_history_id", :unique => true
  end
end
