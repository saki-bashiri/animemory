class AddIndexToArtists < ActiveRecord::Migration
  def change
    add_index :artists, :kana, :name => "kana"
  end
end
