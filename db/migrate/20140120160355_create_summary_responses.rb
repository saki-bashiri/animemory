class CreateSummaryResponses < ActiveRecord::Migration
  def change
    create_table :summary_responses do |t|
      t.integer :summary_id, :null => false
      t.integer :res_sort,   :null => false
      t.text :content,       :null => false

      t.timestamps
    end

    add_index :summary_responses, [:summary_id, :res_sort], :name => "summary_res", :unique => true
    add_index :summary_responses, :created_at, :name => "created_at"
  end
end
