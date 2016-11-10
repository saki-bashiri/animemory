class RenameMedias < ActiveRecord::Migration
  def up
    rename_table :medias, :media
  end

  def down
    rename_table :media, :medias
  end
end
