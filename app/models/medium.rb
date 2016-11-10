class Medium < ActiveRecord::Base
  include MasterTable::Area

  has_many :on_air_schedules

  RECOMMEND_MEDIA_NAMES = [
    "NHK総合", "NHK Eテレ", "フジテレビ", "日本テレビ", "TBS", "テレビ朝日", "テレビ東京",
    "tvk", "チバテレビ", "テレ玉", "BS Japan", "BS-TBS", "BSフジ", "BS朝日", "TOKYO MX",
    "AT-X", "アニマックス", "キッズステーション", "カートゥーンネットワーク", "テレ朝チャンネル",
    "チャンネルNECO", "東映チャンネル", "文化放送(1134)", "TBSチャンネル1", "BS日テレ",
    "群馬テレビ", "とちぎテレビ", "NHK-FM", "バンダイチャンネル", "日テレプラス", "BS11デジタル",
    "TwellV", "ニコニコ生放送", "MUSIC ON! TV", "超!A&G+", "ディズニーXD", "TOKYO FM(80.0)", "ニコニコチャンネル",
    "長崎放送", "長崎文化放送", "テレビ長崎", "長崎国際テレビ", "YouTube", "NHK BSプレミアム", "TOKYO MX2",
    "NACK5(79.5)", "BSスカパー！", "BSアニマックス", "WOWOWプライム", "BSN", "TeNY",
    "新潟テレビ21", "NST", "TBSチャンネル2"]

  class << self
    def area_options_for_select
      MasterTable::Area::KEYS.map{|key| [MasterTable::Area::NAME[key], MasterTable::Area.area_num(key)] }
    end

    def recommend_media_group
      media_group = self.where(:name => RECOMMEND_MEDIA_NAMES).group_by(&:area_to_sym)
      MasterTable::Area.area_syms.map{|sym| {:area_key => sym, :area_name => MasterTable::Area.area_name(sym), :media => media_group[sym]} if media_group[sym].present? }.compact
    end
  end

  def area_name
    MasterTable::Area.area_name(area_id)
  end

  def area_to_sym
    MasterTable::Area.area_to_sym(area_id)
  end
end
