class Episode < ActiveRecord::Base
  attr_accessible :anime_id, :episode, :subtitle, :watched_count, :status

  belongs_to :anime
  has_many :anime_threads
  has_many :on_air_schedules, :conditions => ["on_air_schedules.status = ?", 1]
  has_many :ip_comments

end
