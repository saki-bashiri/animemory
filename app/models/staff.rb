class Staff < ActiveRecord::Base
  attr_accessible :anime_id, :role_id, :creator_id, :special_role, :status, :creator_sort
  belongs_to :anime
  belongs_to :creator
  belongs_to :staff_anime, :class_name => "Anime", :foreign_key => "anime_id"
  belongs_to :role

  after_create :create_channel_notification

  private

  def create_channel_notification
    ChannelNotification.create!(:creator_id => self.creator_id, :anime_id => self.anime_id, :staff_id => self.id)
  end
end
