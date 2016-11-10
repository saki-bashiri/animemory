class AddColumnOtherTitleToAnimes < ActiveRecord::Migration
  def change
    add_column :animes, :other_title, :string, :after => :title
    add_index :animes, :other_title, :name => "other_title"
    add_column :anime_histories, :other_title, :string, :after => :title
  end
end
