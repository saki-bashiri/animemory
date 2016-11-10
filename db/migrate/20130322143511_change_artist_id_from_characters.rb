class ChangeArtistIdFromCharacters < ActiveRecord::Migration
  def up
    change_column(:characters, :artist_id, :integer, :null => true)
  end

  def down
    change_column(:characters, :artist_id, :integer, :null => false)
  end
end
