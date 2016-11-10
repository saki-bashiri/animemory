module AnimeTime
  NOW = Time.now
  ANIME_HOUR = 5

  class << self
    def now
      NOW
    end

    # その時間帯に対する、基準時間を返す 2014-04-01 05:00:00 など
    def start_time(time = Time.now)
      result = time.to_date + ANIME_HOUR.hour
      time.hour >= ANIME_HOUR ? result : (result - 1.day)
    end

    def today
      (NOW - ANIME_HOUR.hour).to_date
    end
  end
end