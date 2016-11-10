class AddColumnAnimeImageIdToAnimeReport < ActiveRecord::Migration
  def up
    add_column :anime_reports, :anime_image_id, :integer
  end

  def down
    remove_column :anime_reports, :anime_image_id
  end
end
