class DropTableAnimeSamples < ActiveRecord::Migration
  def up
    drop_table :anime_samples
  end

  def down
  end
end
