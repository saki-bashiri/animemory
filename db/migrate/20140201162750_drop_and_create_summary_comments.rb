class DropAndCreateSummaryComments < ActiveRecord::Migration
  def up
    drop_table :summary_comments
    create_table :summary_comments do |t|
      t.integer :summary_id,         :null => false
      t.integer :comment_number,     :null => false
      t.text    :content,            :null => false
      t.integer :summary_content_id
      t.integer :content_res_number
      t.timestamps
    end

    add_index :summary_comments, [:summary_id, :comment_number], :name => "summary_res", :unique => true
    add_index :summary_comments, :created_at, :name => "created_at"
    add_index :summary_comments, [:summary_content_id, :content_res_number], :name => "summary_content_res", :unique => true
  end

  def down
  end
end
