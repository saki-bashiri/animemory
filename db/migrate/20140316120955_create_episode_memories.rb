class CreateEpisodeMemories < ActiveRecord::Migration
  def change
    create_table :episode_memories do |t|
      t.integer :episode_id, :null => false
      t.integer :anime_id, :null => false
      t.integer :user_id, :null => false
      t.integer :watch_status, :null => false, :default => 0
      t.timestamps
    end

    add_index :episode_memories, [:episode_id, :user_id], :unique => true
    add_index :episode_memories, :user_id
    add_index :episode_memories, :anime_id
    add_index :episode_memories, :watch_status
    add_index :episode_memories, :updated_at
  end
end
