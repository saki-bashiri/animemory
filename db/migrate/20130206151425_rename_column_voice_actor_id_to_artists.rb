class RenameColumnVoiceActorIdToArtists < ActiveRecord::Migration
  def self.up
    rename_column :artists, :voice_actor_id, :voice_actor_flg
  end

  def self.down
    rename_column :artists, :voice_actor_flg, :voice_actor_id
  end
end
