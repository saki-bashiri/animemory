class AddColumnProductionCommitteeToAnime < ActiveRecord::Migration
  def up
    add_column :animes, :production_committee, :string, :after => :production_id
    change_column :animes, :shoboi_tid, :integer, :after => :kana
    remove_column :animes, :fastest_weekday
    remove_column :animes, :mylist_count
    add_column :songs, :arranger_id, :integer, :after => :songwriter_id

    add_index :staffs, [:anime_id, :role_id, :creator_id], :name => "anime_staffs", :unique => true
    add_index :staffs, [:role_id], :name => "role_id"
    add_index :staffs, [:creator_id], :name => "creator_id"
    remove_index :roles, :name => "index_roles_on_name"

    add_index :artists, :voice_actor_flg, :name => "voice_actor_flg"
    add_index :artists, :singer_flg, :name => "singer_flg"
    add_index :artists, :composer_flg, :name => "composer_flg"
    add_index :artists, :songwriter_flg, :name => "songwriter_flg"

    change_column :productions, :kana, :string, :null => true, :after => :name
  end

  def down

  end
end
