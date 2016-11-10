class OnAirSchedule < ActiveRecord::Base
  belongs_to :anime
  belongs_to :medium
  belongs_to :episode

  class << self
    def get_daily_schedule(user_id, anime_datetime)
      self.includes({:anime => [:anime_image]}, :episode, :medium).
        joins("INNER JOIN mymemories ON mymemories.anime_id = on_air_schedules.anime_id").
        joins("INNER JOIN user_media ON user_media.medium_id = on_air_schedules.medium_id").
        where("mymemories.watch_status = ? AND mymemories.user_id = ?", Mymemory.watch_status_num(:watching), user_id).
        where("user_media.user_id = ?", user_id).
        where("on_air_schedules.on_air_time BETWEEN ? AND ?", anime_datetime - 2.days,  anime_datetime.tomorrow).
        order("on_air_schedules.on_air_time").all.
        each_with_object({:now_on_air => [], :before_on_air => [], :done => []}) do |schedule, hash|
        if schedule.now_on_air?
          hash[:now_on_air] << schedule
        elsif schedule.before_on_air?
          hash[:before_on_air] << schedule
        else
          hash[:done] << schedule
        end
      end
    end
  end

  def now_on_air?
    now = Time.now
    now >= self.on_air_time && now <= ( self.on_air_time + span.minutes )
  end

  def display_on_air_time
    hour = self.on_air_time.hour
    if self.on_air_time.hour.present? && self.on_air_time.hour.to_i < 5
      hour = self.on_air_time.hour + 24
      self.on_air_time -= 1.day
    end
    min = ( self.on_air_time.min < 10 ? "0#{self.on_air_time.min}" : self.on_air_time.min.to_s )
    wdays = ["日", "月", "火", "水", "木", "金", "土"]

    "#{self.on_air_time.month}/#{self.on_air_time.day}(#{wdays[self.on_air_time.wday]}) #{hour}:#{min}"
  end

  def before_on_air?
    now = Time.now
    now < self.on_air_time
  end
end
