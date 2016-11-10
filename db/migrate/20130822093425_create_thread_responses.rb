class CreateThreadResponses < ActiveRecord::Migration
  def change
    create_table :thread_responses do |t|
      t.integer :thread_log_id, :null => false
      t.integer :anchor, :null => false
      t.string :post_cd, :null => false, :default => "", :limit => 9
      t.string :name
      t.string :content, :null => false, :default => "", :limit => 4096
      t.datetime :posted_at, :null => false
      t.integer :anime_id
      t.boolean :delete_flg, :null => false, :default => 0
    end

    add_index :thread_responses, :thread_log_id, :name => "thread_log_id"
    add_index :thread_responses, :anime_id, :name => "anime_id"
  end
end
