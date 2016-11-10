class Origin < ActiveRecord::Base
  has_many :with_origin_animes
  has_many :animes, :through => :with_origin_animes

  COMIC       = 1
  LIGHT_NOVEL = 2
  GAME        = 3
  ANIME       = 4
  WEB         = 5
  NOVEL       = 6

  OriginType = {
    COMIC => "漫画",
    LIGHT_NOVEL => "ライトノベル",
    GAME => "ゲーム",
    WEB => "Web",
    ANIME => "アニメ",
    NOVEL => "小説",
  }
end
