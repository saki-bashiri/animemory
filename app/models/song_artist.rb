class SongArtist < ActiveRecord::Base
  attr_accessible :song_id, :song_artist_type, :artist_sort, :artist_id, :creator_id
  belongs_to :creator
  belongs_to :song

  after_create :create_channel_notification

  class SongArtistType
    SINGER = 1
    SONGWRITER = 2
    COMPOSER = 3
    ARRANGER = 4
    NUM = {:singer => SINGER, :songwriter => SONGWRITER, :composer => COMPOSER, :arranger => ARRANGER}
    KEY = {SINGER => :singer, SONGWRITER => :songwriter, COMPOSER => :composer, :ARRANGER => :arranger}
    KEYS = [:singer, :songwriter, :composer, :arranger]
    NUMS = KEY.keys

    NAME = {:singer => "歌手", :songwriter => "作詞", :composer => "作曲", :arranger => "編曲"}

    ARTISTS_KEY = {:singer => :singers, :songwriter => :songwriters, :composer => :composers, :arranger => :arrangers}

    attr_reader :key

    class << self
      def type_num(sym)
        NUM[sym]
      end

      def type_sym(num)
        KEY[num]
      end

      def type_syms
        KEYS
      end
    end

    def initialize(sym)
      @key = sym
    end

    def name
      NAME[@key] || NAME[:singer]
    end

    def artists_key
      ARTISTS_KEY[@key]
    end
  end

  def singer?
    self.song_artist_type == SongArtistType.type_num(:singer)
  end

  def composer?
    self.song_artist_type == SongArtistType.type_num(:composer)
  end

  def songwriter?
    self.song_artist_type == SongArtistType.type_num(:songwriter)
  end

  def arranger?
    self.song_artist_type == SongArtistType.type_num(:arranger)
  end

  def artist_type_sym
    SongArtistType.type_sym(self.song_artist_type)
  end

  private

  def create_channel_notification
    return unless song = self.song
    ChannelNotification.create!(:creator_id => self.creator_id, :anime_id => song.anime_id, :song_artist_id => self.id)
  end
end