class AddRevisionIdToAnimeHistory < ActiveRecord::Migration
  def self.up
    add_column :anime_histories, :revision_id, :integer, :null => false, :default => 0
    add_index :anime_histories, :revision_id
    add_index :anime_histories, :user_id
    add_index :anime_histories, :anime_id
  end

  def self.down
    remove_column :anime_histories, :revision_id
  end
end
