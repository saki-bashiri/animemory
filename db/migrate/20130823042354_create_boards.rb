class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :sub_domain, :null => false
      t.string :dir, :null => false
      t.string :name, :null => false
      t.timestamps
    end
  end
end
