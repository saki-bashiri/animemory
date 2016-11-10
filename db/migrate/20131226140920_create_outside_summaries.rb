class CreateOutsideSummaries < ActiveRecord::Migration
  def change
    create_table :outside_summaries do |t|
      t.integer  :site_type,   :null => false
      t.string   :url,          :null => false, :limit => 255
      t.string   :title,        :null => false, :limit => 255
      t.datetime :posted_at,   :null => false
      t.string   :description,                  :limit => 255

      t.timestamps
    end

    add_index :outside_summaries, :site_type, :name => "site_type"
    add_index :outside_summaries, :posted_at, :name => "posted_at"
    add_index :outside_summaries, :url,        :name => "url"
  end
end
