class Song < ActiveRecord::Base
  attr_accessible :anime_id, :title, :song_type, :description, :status
  belongs_to :anime
  has_many :song_artists
  has_many :creators, :through => :song_artists

  module SongType
    OP = 1
    ED = 2
    FEATURED = 3
    OTHER = 99

    NUM = {:op => OP, :ed => ED, :featured => FEATURED}
    NAME = {:op => "オープニングテーマ", :ed => "エンディングテーマ", :featured => "挿入歌"}
    KEY = {OP => :op, ED => :ed, FEATURED => :featured}

    class << self
      def type_num(sym)
        NUM[sym] || OTHER
      end

      def type_sym(num)
        KEY[num] || :featured
      end
    end
  end

  class << self
    def song_type_name(sym)
      SongType::NAME[sym]
    end
  end

  def song_type_name
    SongType::NAME[self.song_type_sym]
  end

  def song_type_sym
    SongType.type_sym(self.song_type)
  end

  def op?
    self.song_type == SongType.type_num(:op)
  end

  def ed?
    self.song_type == SongType.type_num(:ed)
  end

  def featured?
    self.song_type == SongType.type_num(:featured)
  end

  def singers
    creators = self.song_artists.all.select{|song_artist| song_artist.singer?}.sort_by(&:artist_sort).map do |song_artist|
      song_artist.creator
    end
    creators.compact
  end

  def composers
    creators = self.song_artists.all.select{|song_artist| song_artist.composer?}.sort_by(&:artist_sort).map do |song_artist|
      song_artist.creator
    end
    creators.compact
  end

  def songwriters
    creators = self.song_artists.all.select{|song_artist| song_artist.songwriter?}.sort_by(&:artist_sort).map do |song_artist|
      song_artist.creator
    end
    creators.compact
  end

  def arrangers
    creators = self.song_artists.all.select{|song_artist| song_artist.arranger?}.sort_by(&:artist_sort).map do |song_artist|
      song_artist.creator
    end
    creators.compact
  end

  def artist_types
    artist_types = self.song_artists.map(&:artist_type_sym).uniq
    SongArtist::SongArtistType.type_syms.select{|sym| artist_types.include?(sym) }.map{|sym| SongArtist::SongArtistType.new(sym)}
  end

  def artists_by_artist_type(artist_type)
    self.try(artist_type.artists_key)
  end
end
