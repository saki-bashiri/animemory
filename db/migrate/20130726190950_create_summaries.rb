class CreateSummaries < ActiveRecord::Migration
  def change
    create_table :summaries do |t|
      t.integer :user_id, :null => false, :default => nil
      t.string  :title,   :null => false, :default => ""

      t.timestamps
    end

    add_index :summaries, :user_id, :name => "user_id"
  end
end
