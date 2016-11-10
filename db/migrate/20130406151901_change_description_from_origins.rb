class ChangeDescriptionFromOrigins < ActiveRecord::Migration
  def up
    change_column :origins,              :description, :text
    change_column :artists,              :description, :text
    change_column :artist_revisions,     :description, :text
    rename_column :characters,          :comment, :description
    rename_column :character_revisions, :comment, :description
    change_column :characters,           :description, :text
    change_column :character_revisions,  :description, :text
    change_column :creators,             :description, :text, :null => true, :default => ""
    change_column :creator_revisions,    :description, :text, :null => true, :default => ""
    change_column :origin_revisions,     :description, :text
    change_column :productions,          :description, :text
    change_column :production_revisions, :description, :text
    change_column :songs,                :description, :text
    change_column :song_histories,       :description, :text
  end

  def down
  end
end
