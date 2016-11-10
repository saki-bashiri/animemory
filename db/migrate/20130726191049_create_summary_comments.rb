class CreateSummaryComments < ActiveRecord::Migration
  def change
    create_table :summary_comments do |t|
      t.integer :summary_id,      :null => false
      t.integer :comment_id,      :null => false
      t.column  :size,  :tinyint, :null => false, :default => 0
      t.column  :color, :tinyint, :null => false, :default => 0

      t.timestamps
    end

    add_index :summary_comments, :summary_id, :name => "summary_id"
  end
end
