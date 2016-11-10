class AddIndexToUnits < ActiveRecord::Migration
  def change
    add_index :units, :unit_id, :name => "unit_id"
    add_index :units, :artist_id, :name => "artist_id"
  end
end
