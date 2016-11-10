class AddColumnAnimeIdToSummaries < ActiveRecord::Migration
  def change
    add_column :summaries, :anime_id, :integer, :null => false, :default => 0
    add_index :summaries, :anime_id, :name => "anime_id"
  end
end
