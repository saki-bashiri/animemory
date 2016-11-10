class ScheduleController < ApplicationController
  http_basic_authenticate_with :name => 'shinkawasaki', :pass => 'nakayamadaigo', :only => [:edit, :edit_conf] if Rails.env == "production"
  def edit
    raise if params[:schedule].blank?
    @schedule = OnAirSchedule.includes(:anime).find_by_id(params[:schedule].to_i)
    raise if @schedule.blank?
    @anime = @schedule.anime
    @media = @schedule.medium
    @episode = @schedule.episode
  end

  def edit_conf
    raise unless request.post? && @user.present?
    @schedule = OnAirSchedule.includes(:anime, :medium).find_by_id(params[:schedule])
    raise if @schedule.blank?
    @anime = @schedule.anime
    @media = @schedule.medium
    @episode = @schedule.episode

    if @schedule.present? && params[:conf].present?
      @date = Date.strptime(params[:date].to_s)
      @time = Time.zone.parse(params[:date].to_s + " " + params[:time].to_s)
      @span = params[:span]
      @memo = params[:memo].to_s
      @anime = @schedule.anime
      @media = @schedule.medium
    elsif @schedule.present? && params[:commit].present?
      @time = Time.zone.parse(params[:time].to_s)
      @schedule.on_air_time = @time
      @schedule.memo = params[:memo].to_s
      @schedule.temporary_flg = 1
      @schedule.save!

      redirect_to :controller => "anime", :action => "dtl", :anime => @schedule.anime_id
    end
  end
  def add
    @anime = Anime.where("id = ?", params[:anime].to_i).first
    raise "指定のアニメが見つかりません" if @anime.blank?
    @media = Medium.all.map{|m| [m.name, m.id]}
  end

  def add_conf
    raise if params[:anime].blank? || params[:medium].blank? || params[:on_air_time].blank? || params[:span].to_i < 1
    if request.post?
      anime_id = params[:anime].to_i
      anime = Anime.includes(:episodes).where(["animes.id = ?", anime_id]).first
      medium = Medium.where("id = ?", params[:medium].to_i).first
      raise if anime.blank? || medium.blank?

      OnAirSchedule.transaction do
        anime.episodes.each do |ep|
          schedule = OnAirSchedule.where("episode_id = ? and medium_id = ?", ep.id, medium.id).first
          if schedule.blank?
            schedule = OnAirSchedule.new
            schedule.episode_id = ep.id
            schedule.anime_id = anime.id
          end
          schedule.medium_id = medium.id
          time = params[:on_air_time]
          on_air_time = Time.zone.parse(time[:date].to_s) + time[:hour].to_i*60*60 + time[:minute].to_i*60
          set_time = on_air_time + 7*(ep.episode.to_i - 1).days

          schedule.span = params[:span].to_i
          schedule.weekday = ( schedule.on_air_time - 5.hours ).wday
          schedule.temporary_flg = 0
          schedule.memo = params[:memo].to_s if params[:memo].present?
          schedule.save!
        end
      end

      redirect_to :controller => "anime", :action => "dtl", :anime => anime.id
      return
    end
  end
end
