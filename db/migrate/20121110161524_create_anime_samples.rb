class CreateAnimeSamples < ActiveRecord::Migration
  def self.up
    create_table :anime_samples do |t|
      t.string :name
      t.integer :age

      t.timestamps
    end
  end

  def self.down
    drop_table :anime_samples
  end
end
