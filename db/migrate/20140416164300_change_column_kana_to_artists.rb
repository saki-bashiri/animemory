class ChangeColumnKanaToArtists < ActiveRecord::Migration
  def up
    change_column :artists, :kana, :string, :null => true, :default => nil, :after => :name
    remove_column :artists, :office_id
    remove_column :artists, :record_office_id
  end

  def down
  end
end
