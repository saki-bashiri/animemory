class AddIndexToCharacters < ActiveRecord::Migration
  def change
    add_index :characters, :name, {:name => "name"}
  end
end
