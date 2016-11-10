class CreateSummaryImages < ActiveRecord::Migration
  def change
    create_table :summary_images do |t|
      t.integer :summary_id, :null => false
      t.integer :summary_content_id
      t.integer :anime_image_id, :null => false
      t.integer :image_sort, :null => false, :default => 0
    end

    add_index :summary_images, :summary_id, :name => "summary_id"
    add_index :summary_images, [:summary_content_id, :image_sort], :name => "summary_content_sort"

    add_column :summaries, :description, :string, :limit => 255

    add_column :summary_contents, :anchor, :integer
    add_column :summary_contents, :post_cd, :string, :limit => 9
    add_column :summary_contents, :name, :string
    add_column :summary_contents, :posted_at, :datetime
  end
end
