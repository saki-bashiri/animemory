class ChangeIndexFromOnAirSchedules < ActiveRecord::Migration
  def up
    remove_index :on_air_schedules, :name => "media_episode"
    add_index :on_air_schedules, :medium_id, :name => "medium_id"
    add_index :on_air_schedules, :episode_id, :name => "episode_id"
  end

  def down
  end
end
