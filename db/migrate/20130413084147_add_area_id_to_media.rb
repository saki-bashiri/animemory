class AddAreaIdToMedia < ActiveRecord::Migration
  def change
    add_column :media, :area_id, :integer, :null => false, :default => 0
    add_index  :media, :area_id, :name => 'area_id'
  end
end
