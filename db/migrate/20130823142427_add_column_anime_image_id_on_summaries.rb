class AddColumnAnimeImageIdOnSummaries < ActiveRecord::Migration
  def up
    add_column :summaries, :anime_image_id, :integer
  end

  def down
  end
end
