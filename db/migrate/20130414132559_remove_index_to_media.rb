class RemoveIndexToMedia < ActiveRecord::Migration
  def up
    remove_index :media, :name => "index_medias_on_name"
  end

  def down
  end
end
