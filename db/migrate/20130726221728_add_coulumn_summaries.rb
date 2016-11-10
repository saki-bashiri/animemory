class AddCoulumnSummaries < ActiveRecord::Migration
  def up
    add_column :summary_comments, :sort, :integer, :null => false, :default => 1
    add_column :summaries, :anime_thread_id, :integer
    add_index :summary_comments, :sort, :name => "sort"
    add_index :summaries, :anime_thread_id, :name => "anime_thread_id"
  end

  def down
  end
end
