class AddIndexOnAirSchedules < ActiveRecord::Migration
  def up
    add_index :on_air_schedules, :default_on_air_time, :name => "default_on_air_time"
    add_index :on_air_schedules, :weekday, :name => "weekday"
    add_index :on_air_schedules, [:episode_id, :medium_id], :name => "media_episode"
    remove_index :on_air_schedules, :name => "index_on_air_schedules_on_episode_id"
    remove_index :on_air_schedules, :name => "index_on_air_schedules_on_medium_id"
  end

  def down
  end
end
