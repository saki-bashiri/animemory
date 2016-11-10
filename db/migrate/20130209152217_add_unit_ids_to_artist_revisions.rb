class AddUnitIdsToArtistRevisions < ActiveRecord::Migration
  def self.up
    add_column :artist_revisions, :unit_ids, :string, :default => ""
  end

  def self.down
    remove_column :artist_revisions, :unit_ids
  end
end
