class AddCommentOnAnimeHistories < ActiveRecord::Migration
  def up
    add_column :anime_histories, :comment, :string, :null => false, :default => ""
  end

  def down
    remove_column :anime_histories, :comment
  end
end
