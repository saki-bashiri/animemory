class AddColumnCreatorSortToStaffs < ActiveRecord::Migration
  def change
    add_column :staffs, :creator_sort, :integer, :null => false, :default => 0, :after => :role_id
    add_index :staffs, :creator_sort, :name => "creator_sort"
  end
end
