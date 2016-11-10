class AddColumnCharaSortToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :chara_sort, :integer, :null => false , :default => 0, :after => :kana
    add_index :characters, [:anime_id, :chara_sort], :name => "anime_chara_sort"
  end
end
