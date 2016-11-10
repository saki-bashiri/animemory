class CreateOriginRevisions < ActiveRecord::Migration
  def self.up
    create_table :origin_revisions do |t|
      t.integer :origin_id, :null => false, :default => 0
      t.string :title, :null => false, :default => ""
      t.integer :original_type, :null => false, :default => 0, :limit => 4
      t.string :description, :null => false, :default => ""
      t.integer :status, :null => false, :default => 1, :limit => 4
      t.integer :user_id, :null => false, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :origin_revisions
  end
end
