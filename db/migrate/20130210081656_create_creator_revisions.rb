class CreateCreatorRevisions < ActiveRecord::Migration
  def self.up
    create_table :creator_revisions do |t|
      t.integer :creator_id, :null => false, :default => 0
      t.string :name, :null => false, :default => ""
      t.integer :main_role_id, :null => false, :default => 0
      t.integer :main_anime_id, :null => false, :default => 0
      t.string :description, :null => false, :default => 0
      t.integer :user_id, :null => false, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :creator_revisions
  end
end
