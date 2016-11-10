class RenameCharactersVoiceActorIdToArtistId < ActiveRecord::Migration
  def self.up
    rename_column :characters, :voice_actor_id, :artist_id
  end

  def self.down
    remove_column :characters, :artist_id, :voice_actor_id
  end
end
