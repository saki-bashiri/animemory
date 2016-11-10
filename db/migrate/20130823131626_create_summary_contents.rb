class CreateSummaryContents < ActiveRecord::Migration
  def change
    create_table :summary_contents do |t|
      t.integer :summary_id, :null => false
      t.integer :sort, :null => false, :default => 0
      t.text :content, :null => false, :default => ""
    end
    add_index :summary_contents, [:summary_id, :sort], :name => "summary_id_sort", :unique => true
  end
end
