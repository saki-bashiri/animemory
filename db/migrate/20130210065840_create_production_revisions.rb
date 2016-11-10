class CreateProductionRevisions < ActiveRecord::Migration
  def self.up
    create_table :production_revisions do |t|
      t.integer :production_id, :null => false, :default => 0
      t.string :name, :null => false, :default => ""
      t.string :kana, :null => false, :default => ""
      t.string :description, :default => ""
      t.integer :status, :null => false, :default => 0, :limit => 4
      t.integer :user_id, :null => false, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :production_revisions
  end
end
