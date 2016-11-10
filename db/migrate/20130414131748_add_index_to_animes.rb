class AddIndexToAnimes < ActiveRecord::Migration
  def change
    add_index :animes, :kana, :name => "kana"
    add_index :animes, :status, :name => "status"
    add_index :animes, :created_at, :name => "created_at"
  end
end
