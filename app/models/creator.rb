class Creator < ActiveRecord::Base
  attr_accessible :name, :kana, :description, :staff_flg, :production_flg, :unit_flg, :voice_actor_flg, :singer_flg, :songwriter_flg, :composer_flg
  has_many :staffs
  has_many :animes, :through => :staffs
  has_many :staff_animes, :class_name => "Anime", :through => :staffs
  has_many :roles, :through => :staffs
  has_many :creator_revisions
  has_many :units, :class_name => "Unit", :foreign_key => "unit_id"
  has_many :belongs_units, :class_name => "Unit", :foreign_key => "creator_id"
  has_many :unit_creators, :class_name => "Creator", :through => :belongs_units
  has_many :creators, :through => :units
  has_many :my_channels
  has_many :song_artists
  has_many :songs, :through => :song_artists
  has_many :characters

  class CreatorLabel
    attr_reader :type

    NAME = {:voice_actor => "声優", :production => "制作会社", :singer => "歌手", :songwriter => "作詞",
      :composer => "作曲", :staff => "スタッフ"}

    CREATOR_COLUMN = {:voice_actor => :voice_actor_flg, :production => :production_flg, :singer => :singer_flg,
      :songwriter => :songwriter_flg, :composer => :composer_flg, :staff => :staff_flg}

    KEYS = [:voice_actor, :production, :singer, :songwriter, :composer, :staff]

    class << self
      def add_where_by_types(creator_class, types)
        result = creator_class
        types.each do |type|
          result = result.where(CREATOR_COLUMN[type] => true)
        end
        result
      end
    end


    def initialize(type)
      @type = type
    end

    def name
      NAME[@type]
    end

    def artist?
      [:singer, :songwriter, :composer].include?(@type)
    end
  end

  def production?
    self.production_flg
  end

  def voice_actor?
    self.voice_actor_flg
  end

  def artist?
    self.labels.any?{|label| label.artist? }
  end

  def display_name
    return self.name unless self.unit_flg

    unit_members = self.creators
    member_names = unit_members.map do |unit_member|
      if unit_member.unit_flg
        "#{unit_member.name}(#{unit_member.creators.map(&:name).join(", ")})"
      else
        unit_member.name
      end
    end
    "#{self.name}(#{member_names.join(", ")})"
  end

  def labels
    labels = []
    labels << CreatorLabel.new(:voice_actor) if self.voice_actor_flg
    labels << CreatorLabel.new(:production) if self.production_flg
    labels << CreatorLabel.new(:singer) if self.singer_flg
    labels << CreatorLabel.new(:songwriter) if self.songwriter_flg
    labels << CreatorLabel.new(:composer) if self.composer_flg
    labels << CreatorLabel.new(:staff) if self.staff_flg
    labels
  end

  def songs_per_year
    result = {}
    song_artists = self.song_artists
    if ( unit_creators = self.unit_creators ).present?
      self.unit_creators.each{|c| song_artists += c.song_artists }
    end

    if unit_creators.present?
      unit_creators.each{|c| song_artists += c.unit_creators.map(&:song_artists).flatten if c.unit_creators.present? }
    end

    song_artists.sort_by{|sa| sa.song.try(:anime).try(:started_on)}.each do |song_artist|
      year = song_artist.song.try(:anime).try(:started_on).try(:year).to_i
      result[year] ||= []
      result[year] << song_artist.song
    end
    result
  end

  def sorted_characters
    result = {}
    self.characters.each do |character|
      anime = character.anime
      starten_on = anime.try(:started_on)
      if starten_on
        result[starten_on.year] ||= []
        result[starten_on.year] << character
      else
        result[0] ||= []
        result[0] << character
      end
    end
    result.keys.sort.map{|year| {:year => year, :characters => result[year]} }
  end

  def sorted_staffs
    result = {}
    self.staffs.each do |staff|
      anime = staff.anime
      starten_on = anime.try(:started_on)
      if starten_on
        result[starten_on.year] ||= []
        result[starten_on.year] << staff
      else
        result[0] ||= []
        result[0] << staff
      end
    end
    result.keys.sort.map{|year| {:year => year, :staffs => result[year]} }
  end

  def sorted_songs
    result = {}
    self.songs.uniq.each do |song|
      anime = song.anime
      starten_on = anime.try(:started_on)
      if starten_on
        result[starten_on.year] ||= []
        result[starten_on.year] << song
      else
        result[0] ||= []
        result[0] << song
      end
    end
    result.keys.sort.map{|year| {:year => year, :songs => result[year]} }
  end

  class << self
    def where_label_types(types)
      types = [types] unless types.is_a?(Array)
      CreatorLabel.add_where_by_types(self, types)
    end
  end
end
