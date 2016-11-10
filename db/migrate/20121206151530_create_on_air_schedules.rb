class CreateOnAirSchedules < ActiveRecord::Migration
  def self.up
    create_table :on_air_schedules do |t|
      t.integer :episode_id, :null => false
      t.integer :anime_id, :null => false
      t.integer :media_id, :null => false
      t.datetime :default_on_air_time, :null => false
      t.datetime :on_air_time
      t.integer :span, :null => false, :default => 30
      t.integer :weekday, :null => false
      t.integer :temporary_flg, :default => 0
      t.integer :status, :null => false, :default => 1
      t.integer :editor_id, :null => false
      t.string :memo

      t.timestamps
    end
    add_index :on_air_schedules, :episode_id
    add_index :on_air_schedules, :anime_id
    add_index :on_air_schedules, :media_id
  end

  def self.down
    drop_table :on_air_schedules
  end
end
