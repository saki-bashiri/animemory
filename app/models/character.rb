class Character < ActiveRecord::Base
  attr_accessible :anime_id, :artist_id, :name, :kana, :description, :status, :chara_sort, :creator_id
  belongs_to :anime
  belongs_to :creator
  after_create :create_channel_notification

  private

  def create_channel_notification
    ChannelNotification.create!(:creator_id => self.creator_id, :anime_id => self.anime_id, :character_id => self.id)
  end
end
