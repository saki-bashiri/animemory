class CreateAnimeImages < ActiveRecord::Migration
  def change
    create_table :anime_images do |t|
      t.integer :anime_id, :null => false, :default => 0
      t.integer :user_id, :null => false, :default => 0
      t.string :comment, :default => "", :limit => 200
      t.integer :image_type, :null => false, :default => 0
      t.integer :status, :null => false, :default => 1
      t.integer :sort, :null => false , :default => 1

      t.timestamps
    end
    
    add_index :anime_images, :anime_id, :name => "anime_id"
    add_index :anime_images, :user_id, :name => "user_id"
    add_index :anime_images, :image_type, :name => "image_type"
    add_index :anime_images, :status,     :name => "status"
    add_index :anime_images, :sort,       :name => "sort"
  end
end
