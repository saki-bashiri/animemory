class RenameColumnVoiceActorIdToVoiceActorFlgTableArtistRevisions < ActiveRecord::Migration
  def self.up
    rename_column :artist_revisions, :voice_actor_id, :voice_actor_flg
  end 

  def self.down
    rename_column :artist_revisions, :voice_actor_id, :voice_actor_flg 
  end
end
