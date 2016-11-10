class RenameColumnMediaId < ActiveRecord::Migration
  def up
    remove_index :on_air_schedules, :name => 'index_on_air_schedules_on_media_id'
    rename_column :on_air_schedules, :media_id, :medium_id
    add_index :on_air_schedules, :medium_id
  end

  def down
    remove_index :on_air_schedules, :name => 'index_on_air_schedules_on_medium_id'
    rename_column :on_air_schedules, :medium_id, :media_id
    add_index :on_air_schedules, :media_id
  end
end
