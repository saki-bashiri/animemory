class AddColumnToAnimes < ActiveRecord::Migration
  def change
    add_column :animes, :shoboi_tid, :integer
    add_index :animes, :shoboi_tid, :name => "shoboi_tid", :unique => true

    add_column :media, :shoboi_chid, :integer
    add_index :media, :shoboi_chid, :name => "shoboi_chid", :unique => true

    add_column :on_air_schedules, :repeat_flg, :boolean, :default => 0
    add_column :on_air_schedules, :offset, :integer, :default => 0
    change_column :on_air_schedules, :default_on_air_time, :datetime, :null => true
    remove_column :on_air_schedules, :editor_id
  end
end
