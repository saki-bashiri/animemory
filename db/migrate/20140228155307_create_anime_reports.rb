class CreateAnimeReports < ActiveRecord::Migration
  def change
    create_table :anime_reports do |t|
      t.integer :anime_id, :null => false
      t.integer :report_type, :null => false
      t.datetime :reported_on, :null => false
      t.integer :target
      t.integer :target_id

      t.timestamps
    end

    add_index :anime_reports, :anime_id, :name => "anime_id"
    add_index :anime_reports, :report_type, :name => "report_type"
    add_index :anime_reports, :reported_on, :name => "reported_on"
  end
end
