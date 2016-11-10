class AddNoEpisodeFlgToAnimeThreads < ActiveRecord::Migration
  def change
    add_column :anime_threads, :no_episode_flg, :boolean, :null => false, :default => 0
    change_column :anime_threads, :episode_id, :integer, :null => true, :default => nil
  end
end
