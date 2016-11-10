class CreateStaffs < ActiveRecord::Migration
  def self.up
    create_table :staffs do |t|
      t.integer :anime_id, :null => false, :default => 0
      t.integer :creator_id, :null => false, :default => 0
      t.integer :role_id, :default => 0
      t.string :special_role, :default => ""
      t.integer :status, :null => false, :default => 1, :limit => 4

      t.timestamps
    end
  end

  def self.down
    drop_table :staffs
  end
end
