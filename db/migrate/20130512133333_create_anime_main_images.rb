class CreateAnimeMainImages < ActiveRecord::Migration
  def change
    create_table :anime_main_images do |t|
      t.integer :anime_id,        :null => false, :default => 0
      t.integer :anime_image_id, :null => false, :default => 0
      t.timestamps
    end

    add_index :anime_main_images, :anime_id, :unique => true, :name => "anime_id"
  end
end
