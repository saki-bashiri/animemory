class ShoboiManager
  DOMAIN   = "http://cal.syoboi.jp/"
  API_PATH = "rss2.php"

  attr_reader :calenders, :channels

  def initialize(start_time, days)
    @now = Time.zone.now
    @start_time = start_time
    @days   = days
    get_json_data
  end

  def cal_animes
    @calenders.map{|calender| calender["Title"]}.uniq
  end

  def reflesh_schedules
    user = User.where(:admin_status => true).first
    @calenders.each_slice(100) do |chunked_calenders|
      OnAirSchedule.transaction do
        chunked_calenders.each do |calender|
          next unless [1,5,7,10].include?(calender["Cat"].to_i)
          tid = calender["TID"].to_i
          anime = Anime.where("shoboi_tid = ?", tid).first
          if anime.blank?
            anime = Anime.new
            hash = {:title => calender["Title"], :kana => "", :shoboi_tid => tid,
                    :comment => "管理者登録", :is_admin => true}
            anime.set_attributes(hash, user)
            next if Anime.where(:title => anime.title).readonly(false).first.present?
            missing_anime_log(calender) and next unless anime.valid?
            anime.save!
          end

          episode_count = calender["Count"].to_i
          episode = Episode.where("anime_id = ? and episode = ?", anime.id, episode_count).first
          if episode.blank?
            episode = Episode.new
            episode.anime_id = anime.id
            episode.episode  = episode_count
            episode.subtitle = calender["SubTitle"]
            episode.save!
          else
            episode.subtitle = calender["SubTitle"]
            episode.save! if episode.changed?
          end

          chid = calender["ChID"].to_i
          media = Medium.where("shoboi_chid = ?", chid).first
          if media.blank?
            media = Medium.new
            media.name = calender["ChName"]
            media.shoboi_chid = chid
            media.media_type = 0
            media.save!
          end

          on_air_time = Time.zone.at(calender["StTime"].to_i) rescue nil
          end_time = Time.zone.at(calender["EdTime"].to_i) rescue nil
          next if on_air_time.blank? || end_time.blank?

          sc = OnAirSchedule.where("episode_id = ? and medium_id = ? and on_air_time BETWEEN ? AND ?", episode.id, media.id, on_air_time - 14.days, on_air_time + 14.days).first

          span = ((end_time - on_air_time) / 60).round
          offset = calender["OffsetA"].to_i
          repeat_flg = calender["Flag"].to_i == 8

          if sc.blank?
            new_schedule = OnAirSchedule.new
            new_schedule.anime_id    = episode.anime_id
            new_schedule.episode_id  = episode.id
            new_schedule.medium_id   = media.id
            new_schedule.on_air_time = on_air_time
            new_schedule.span        = span
            new_schedule.offset      = offset
            new_schedule.repeat_flg  = repeat_flg
            new_schedule.weekday     = (on_air_time - 5.hours).wday
            new_schedule.save!
          else
            sc.on_air_time = on_air_time
            sc.span        = span
            sc.offset      = offset
            sc.repeat_flg  = repeat_flg
            sc.weekday     = (on_air_time - 5.hours).wday
            sc.save!
          end
        end
      end
    end
  end

  private

  def get_json_data(header={})
    url = DOMAIN + API_PATH + "?start=#{@start_time.strftime('%Y%m%d%H%M')}&days=#{@days.to_i}&alt=json&usr=1"
    uri = URI(url)
    http = Net::HTTP.new(uri.host)
    response = http.get(uri.request_uri, header)
    json = response.body
    @json_hash = JSON.parse(json)
    @calenders = @json_hash["items"]
    @channels   = @json_hash["chInfo"]
  end

  def missing_anime_log(calender)
    @logger ||= ActiveSupport::BufferedLogger.new(File.join(Rails.root, 'log', "missing_anime_#{@now.strftime('%Y%m%d')}.log"))
    anime_title = calender["Title"]
    shoboi_tid  = calender["TID"].to_i

    @logger.info "#{shoboi_tid},#{anime_title}"
  end
end
