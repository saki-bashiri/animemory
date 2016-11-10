class CreateTagGroups < ActiveRecord::Migration
  def self.up
    create_table :tag_groups do |t|
      t.integer :anime_id, :null => false
      t.integer :tag_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :tag_groups
  end
end
