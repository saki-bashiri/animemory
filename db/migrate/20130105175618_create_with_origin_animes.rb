class CreateWithOriginAnimes < ActiveRecord::Migration
  def self.up
    create_table :with_origin_animes do |t|
      t.integer :origin_id, :null => false, :default => 0
      t.integer :anime_id, :null => false, :default => 0

      t.timestamps
    end
    
    add_index :with_origin_animes, :origin_id
    add_index :with_origin_animes, :anime_id
  end

  def self.down
    drop_table :with_origin_animes
  end
end
