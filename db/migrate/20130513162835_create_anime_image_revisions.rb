class CreateAnimeImageRevisions < ActiveRecord::Migration
  def change
    create_table :anime_image_revisions do |t|
      t.integer :anime_image_id, :null => false, :default => 0
      t.integer :user_id, :null => false, :default => 0
      t.integer :draft_flg, :null => false, :default => 0

      t.timestamps
    end

    add_index :anime_image_revisions, :anime_image_id, :name => "anime_image_id"
    add_index :anime_image_revisions, :user_id, :name => "user_id"
  end
end
