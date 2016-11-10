class DropComposers < ActiveRecord::Migration
  def up
    drop_table :composers
    drop_table :singers
    drop_table :songwriters
    drop_table :voice_actors
  end

  def down
  end
end
