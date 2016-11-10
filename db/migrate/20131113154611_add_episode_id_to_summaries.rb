class AddEpisodeIdToSummaries < ActiveRecord::Migration
  def change
    add_column :summaries, :episode_id, :integer
    add_index :summaries, :episode_id, :name => "episode_id"
  end
end
