class AddUniqueIndex < ActiveRecord::Migration
  def change
    add_index :animes, :title, :name => "unique_index_title", :unique => true
    # add_index :artists. :name, :unique => true
    # add_index :creators, :name, :unique => true
    add_index :origins, :title, :name => "unique_index_title", :unique => true
    add_index :anime_counts, :anime_id, :name => "unique_index_anime_id", :unique => true
    # add_index :medias, :name, :unique => true
    # add_index :productions, :name, :unique => true
    # add_index :roles, :name, :unique => true
    # add_index :tags, :name, :unique => true
    add_index :users, :mail_address, :name => "unique_index_mail_address", :unique => true
  end
end
