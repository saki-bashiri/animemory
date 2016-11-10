class CreateOutsideSites < ActiveRecord::Migration
  def change
    create_table :outside_sites do |t|
      t.string  :site_name, :null => false
      t.string  :url,       :null => false
      t.string  :rss_url,   :null => false
      t.integer :status,    :null => false, :default => 0

      t.timestamps
    end

    add_column :outside_summaries, :outside_site_id, :integer
  end
end
