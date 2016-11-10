class AddSortToComments < ActiveRecord::Migration
  def change
    add_column :comments, :anchor, :integer, :null => false, :default => 0
    add_index  :comments, [:anime_thread_id, :anchor], :name => "anchor", :unique => true
  end
end
