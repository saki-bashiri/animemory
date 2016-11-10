class ChannelNotification < ActiveRecord::Base
  attr_accessible :creator_id, :anime_id, :staff_id, :song_artist_id, :character_id, :created_at

  belongs_to :creator
  belongs_to :anime
  belongs_to :staff
  belongs_to :staff
  belongs_to :character
  belongs_to :song_artist
  has_one :song, :through => :song_artist

  NEW_BORDER = 1.week

  class ChannelRole
    ROLE_NAME = {:character => "声優", :singer => "歌手", :composer => "作曲", :songwriter => "作詞", :arranger => "編曲"}

    ACTION_TEXT = {:character => "演じました", :singer => "歌いました", :composer => "作曲しました", :songwriter => "作詞しました", :arranger => "編曲しました",
      :staff => "担当しました"}

    def initialize(notification)
      @channel_type = if notification.staff_id.present?
                        :staff
                      elsif notification.character_id.present?
                        :character
                      elsif notification.song_artist.present?
                        notification.song_artist.artist_type_sym
                      end
      @staff = notification.staff
      @character = notification.character
      @song_artist = notification.song_artist
    end

    def role_name
      if @staff
        @staff.role.name
      else
        ROLE_NAME[@channel_type]
      end
    end

    def target_name
      case @channel_type
      when :staff
        @staff.role.name
      when :singer, :composer, :songwriter, :arranger
        "「#{@song_artist.song.title}」"
      when :character
        "「#{@character.name}」"
      end
    end

    def action_text
      ACTION_TEXT[@channel_type]
    end
  end

  class << self
    def where_new_notice
      self.where("channel_notifications.created_at > ?", Time.now - NEW_BORDER)
    end
  end

  def role_name
    ChannelRole.new(self).role_name
  end

  def target_name
    ChannelRole.new(self).target_name
  end

  def action_text
    ChannelRole.new(self).action_text
  end

  def new?
    self.created_at > Time.now - NEW_BORDER
  end
end