class CreateUserCounts < ActiveRecord::Migration
  def change
    create_table :user_counts do |t|
      t.integer :user_id, :null => false
      t.integer :access_count, :null => false, :default => 0
      t.timestamps
    end

    add_index :user_counts, :user_id, :name => "user_id"
  end
end
