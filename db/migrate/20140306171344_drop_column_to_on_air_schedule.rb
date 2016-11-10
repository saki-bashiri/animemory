class DropColumnToOnAirSchedule < ActiveRecord::Migration
  def up
    remove_column :on_air_schedules, :default_on_air_time
    remove_column :on_air_schedules, :temporary_flg
  end

  def down
  end
end
