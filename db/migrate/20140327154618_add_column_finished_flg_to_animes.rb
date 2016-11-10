class AddColumnFinishedFlgToAnimes < ActiveRecord::Migration
  def change
    add_column :animes, :finish_flg, :boolean, :null => false, :default => false, :after => :finished_on
    add_index :animes, :finish_flg, :name => "finish_flg"

    change_column :on_air_schedules, :repeat_flg, :boolean, :null => false, :default => false, :after => :status
    change_column :on_air_schedules, :offset, :integer, :null => false, :default => 0, :after => :on_air_time
    add_column :on_air_schedules, :new_flg, :boolean, :null => false, :default => false, :after => :repeat_flg
    add_column :on_air_schedules, :last_flg, :boolean, :null => false, :default => false, :after => :new_flg
    add_index :on_air_schedules, :new_flg, :name => "new_flg"
    add_index :on_air_schedules, :last_flg, :name => "last_flg"
  end
end
