class CreateSongwriters < ActiveRecord::Migration
  def self.up
    create_table :songwriters do |t|
      t.string :name, :null => false
      t.string :kana, :null => false
      t.string :description, :default => ""

      t.timestamps
    end
  end

  def self.down
    drop_table :songwriters
  end
end
