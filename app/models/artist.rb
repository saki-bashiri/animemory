class Artist < ActiveRecord::Base
  attr_accessible :name, :kana, :nickname, :birthday, :description, :unit_flg, :voice_actor_flg,
                  :office_id, :record_office_id, :singer_flg, :composer_flg, :songwriter_flg

  has_many :sing_songs, :class_name => "Song", :foreign_key => "singer_id"
  has_many :compose_songs, :class_name => "Song", :foreign_key => "composer_id"
  has_many :write_songs, :class_name => "Song", :foreign_key => "songwriter_id"
  has_many :characters
  has_many :animes, :through => :characters
  has_many :units, :class_name => "Unit", :foreign_key => "unit_id"
end
