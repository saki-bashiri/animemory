class AddColumnDraftFlgToAnimeImages < ActiveRecord::Migration
  def change
    add_column :anime_images, :draft_flg, :boolean, :null => false, :default => 0
    add_index :anime_images, :draft_flg, :name => "draft_flg"
  end
end
