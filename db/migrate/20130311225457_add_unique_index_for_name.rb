class AddUniqueIndexForName < ActiveRecord::Migration
  def up
    add_index :artists, :name, {:name => "unique_index_name", :unique => true}
    add_index :creators, :name, {:name => "unique_index_name", :unique => true}
    add_index :medias, :name, {:name => "unique_index_name", :unique => true}
    add_index :productions, :name, {:name => "unique_index_name", :unique => true}
    add_index :roles, :name, {:name => "unique_index_name", :unique => true}
    add_index :tags, :name, {:name => "unique_index_name", :unique => true}
  end

  def down
  end
end
