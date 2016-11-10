class CreateUserMedia < ActiveRecord::Migration
  def change
    create_table :user_media do |t|
      t.integer :user_id, :null => false
      t.integer :medium_id, :null => false

      t.timestamps
    end

    add_index :user_media, [:user_id, :medium_id], :name => "user_unique_medium_id", :unique => true
  end
end
