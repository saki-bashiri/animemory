require "csv"

class AdminController < ApplicationController
  before_filter :access_check

  def index
  end

  def anime
    @animes = Anime
    if params[:aid].to_i > 0
      @animes = @animes.where("animes.id = ?", params[:aid].to_i)
    end

    if params[:title].present?
      @animes = @animes.where("animes.title like ?", "%#{params[:title].to_s}%")
    end

    if params[:kana].present?
      @animes = @animes.where("animes.kana like ?", "%##{params[:kana]}%")
    end

    page = params[:pg].to_i > 0 ? params[:pg].to_i : 1
    @animes = @animes.page(page).per(20)
  end

  def anime_edit
    @anime = Anime.includes(:songs, :characters, :episodes).where("animes.id = ?", params[:aid].to_i).first
    redirect_to :action => "anime" and return if @anime.blank?
  end

  def anime_edit_conf
    raise "error" if ( anime_params = params[:anime]).blank?
    @revision = AnimeHistory.where("anime_id = ?", anime_params[:id].to_i).order("anime_histories.id DESC").first
    if @revision.blank?
      raise "なんかおかしい"
    end
    @anime = @revision.anime

    @anime.set_attributes(params[:anime].merge(:comment => "アニメモリ管理編集"), @user, @revision, :is_admin => true)

    if params[:commit]
      raise if !@anime.valid?
      @anime.save!
      redirect_to :action => "anime_edit", :aid => @anime.id
      return
    else
      if !@anime.valid?
        render :action => "anime_edit"
        return
      end
    end
  end

  def anime_lump_regist
    if params[:conf].present?
      now = Time.now.strftime("%Y%m%d&H%M%S")
      csv = params[:file].read
      open("/tmp/anime_lump_#{now}.csv", "w"){|f| f.write(csv)}
      @animes, count = [], 0
      CSV.foreach("/tmp/anime_lump_#{now}.csv") do |row|
        count += 1
        next if count == 1
        line = row.map{|r| NKF.nkf("-w", r.to_s)}
        next if Anime.where("title = ?", line[0].to_s).first.present?
        anime = Anime.new
        anime_info = {:title => line[0].to_s, :kana => line[1].to_s, :started_on => line[2].to_s,
                      :finished_on => line[3].to_s, :movie_flg => (line[4].to_i == 1), :ep_cnt => line[5].to_i}

        anime.set_attributes(anime_info, @user)
        @animes << anime
      end
    elsif params[:commit].present?
      new_animes = params[:anime]

      Anime.transaction do
        new_animes.each do |new_anime|
          anime_hash = new_anime.dup
          anime_hash[:comment] = "運営登録"
          next if Anime.where("title = ?", anime_hash[:title].to_s).first.present?
          anime = Anime.new
          anime.set_attributes(anime_hash, @user)
          anime.save!
        end
      end
      redirect_to :action => "anime"
      return
    end
  end

  def character_lump_regist
    if params[:conf].present?
      now = Time.now.strftime("%Y%m%d&H%M%S")
      csv = params[:file].read
      open("/tmp/character_lump_#{now}.csv", "w"){|f| f.write(csv)}
      @characters, count = [], 0

      CSV.foreach("/tmp/character_lump_#{now}.csv") do |row|
        count += 1
        next if count == 1
        line = row.map{|r| NKF.nkf("-w", r.to_s)}
        next if Character.where("anime_id = ?", line[0].to_i).where("name = ?", line[1].to_s).first.present?
        character = Character.new
        anime = Anime.find_by_id(line[0].to_i)
        raise "アニメIDおかしい" if anime.blank?
        character.anime_id  = anime.id
        character.name      = line[1].to_s
        character.kana      = line[2].to_s
        artist = Artist.find_by_id(line[3].to_i)
        character.artist_id = artist.present? ? artist.id : nil
        @characters << character
      end
    elsif params[:commit].present?
      new_characters = params[:character]

      Character.transaction do
        new_characters.each do |new_character|
          next if Character.where("anime_id = ?", new_character[:anime_id]).where("name = ?", new_character[:name].to_s).first.present?
          character = Character.new
          character.anime_id        = new_character[:anime_id].to_i
          character.name            = new_character[:name].to_s
          character.kana            = new_character[:kana].to_s
          character.artist_id       = new_character[:artist_id].to_i
          character.save!
        end
      end
      redirect_to :action => "character"
      return
    end
  end

  def shoboi_missing_anime
    log_paths = Dir.glob("#{Rails.root}/log/missing_anime_*.log")
    if log_paths.blank?
      @missing_data = []
      return
    end
    missing_data = []

    log_paths.each do |path|
      i = 0
      File.foreach(path) do |line|
        i += 1
        next if i == 1
        row = line.split(",")
        next if Anime.where("shoboi_tid = ?", row[0].to_i).first.present?
        missing_data << [row[0], row[1]]
      end
      @missing_data = missing_data.uniq
    end
  end

  def character
    page = (params[:pg].to_i > 0 ? params[:pg].to_i : 1 )
    if params[:q].present?
      @characters = Character.includes(:anime, :artist).where("characters.name like ?", "%#{params[:q]}%").page(page).per(20)
    elsif params[:commit].present?
      character = Character.find_by_id(params[:id].to_i)
      character.name = params[:name].to_s
      character.kana = params[:kana].to_s
      artist = Artist.find_by_id(params[:artist_id].to_i)
      character.artist_id = artist.id if artist.present?
      character.save!
      @characters = Character.where("id = ?", character.id).page(page).per(20)
    elsif params[:draft].present?
      character = Character.find_by_id(params[:id].to_i)
      character.status = 2
      character.save!
      @characters = Character.where("id = ?", character.id).page(page).per(20)
    elsif params[:open].present?
      character = Character.find_by_id(params[:id].to_i)
      character.status = 1
      character.save!
      @characters = Character.where("id = ?", character.id).page(page).per(20)
    else
      @characters = Character.order("updated_at DESC").page(page).per(20)
    end
    @artists = Artist.select("id, name").order("id ASC")
  end

  def artist_lump_regist
    if params[:conf].present?
      now = Time.now.strftime("%Y%m%d&H%M%S")
      csv = params[:file].read
      open("/tmp/artist_lump_#{now}.csv", "w"){|f| f.write(csv)}
      @artists, count = [], 0

      CSV.foreach("/tmp/artist_lump_#{now}.csv") do |row|
        count += 1
        next if count == 1
        line = row.map{|r| NKF.nkf("-w", r.to_s)}
        next if Artist.where("name = ?", line[0].to_s).first.present?
        artist = Artist.new
        artist.name     = line[0]
        artist.kana     = line[1]
        artist.nickname = line[2] if line[2].present?
        birthday = Date.parse(line[3]) rescue nil
        artist.birthday = birthday if birthday.present?
        artist.voice_actor_flg = 1 if line[4].to_i == 1
        artist.singer_flg      = 1 if line[5].to_i == 1
        artist.composer_flg    = 1 if line[6].to_i == 1
        artist.songwriter_flg  = 1 if line[7].to_i == 1
        @artists << artist
      end
    elsif params[:commit].present?
      new_artists = params[:artist]

      Artist.transaction do
        new_artists.each do |new_artist|
          next if Artist.where("name = ?", new_artist[:name].to_s).first.present?
          artist = Artist.new
          artist.name            = new_artist[:name].to_s
          artist.kana            = new_artist[:kana].to_s
          artist.nickname        = new_artist[:nickname].to_s
          artist.birthday        = Date.parse(new_artist[:birthday]) rescue nil
          artist.voice_actor_flg = (new_artist[:voice_actor_flg].to_i == 1 ? 1 : 0)
          artist.singer_flg      = (new_artist[:singer_flg].to_i == 1 ? 1 : 0)
          artist.composer_flg    = (new_artist[:composer_flg].to_i == 1 ? 1 : 0)
          artist.songwriter_flg  = (new_artist[:songwriter_flg].to_i == 1 ? 1 : 0)
          artist.save!
        end
      end
      redirect_to :action => "artist"
      return
    end
  end

  def artist
    page = (params[:pg].to_i > 0 ? params[:pg].to_i : 1 )
    if params[:q].present?
      @artists = Artist.where("name like ?", "%#{params[:q]}%").page(page).per(20)
    elsif params[:commit].present?
      artist = Artist.find_by_id(params[:id].to_i)
      artist.name = params[:name].to_s
      artist.kana = params[:kana].to_s
      artist.nickname = params[:nickname].to_s
      artist.birthday = Date.parse(params[:birthday]) rescue nil
      artist.voice_actor_flg = (params[:voice_actor_flg].to_i == 1 ? 1 : 0)
      artist.singer_flg      = (params[:singer_flg].to_i == 1 ? 1 : 0)
      artist.composer_flg    = (params[:composer_flg].to_i == 1 ? 1 : 0)
      artist.songwriter_flg  = (params[:songwriter_flg].to_i == 1 ? 1 : 0)
      artist.save!
      @artists = Artist.where("id = ?", artist.id).page(page).per(20)
    else
      @artists = Artist.order("updated_at DESC").page(page).per(20)
    end
  end

  def schedule_lump_regist
    if params[:conf].present?
      now = Time.now.strftime("%Y%m%d&H%M%S")
      csv = params[:file].read
      open("/tmp/artist_lump_#{now}.csv", "w"){|f| f.write(csv)}
      @schedules, count = [], 0

      CSV.foreach("/tmp/artist_lump_#{now}.csv") do |row|
        count += 1
        next if count == 1
        line = row.map{|r| NKF.nkf("-w", r.to_s)}
        anime = Anime.find_by_id(line[0].to_i)
        start_ep = line[1].to_i
        end_ep   = line[2].to_i
        medium = Medium.find_by_id(line[3].to_i)
        base_time = Time.zone.parse(line[4]) rescue nil
        span = line[5].to_i
        next if base_time.blank? || anime.blank? || start_ep > end_ep || medium.blank? || span <= 0

        (start_ep..end_ep).each_with_index do |ep_num, i|
          episode = Episode.where("anime_id = ? AND episode = ?", anime.id, ep_num).first
          next if episode.blank?
          sc = OnAirSchedule.new
          sc.anime_id = episode.anime_id
          sc.episode_id = episode.id
          sc.medium_id = medium.id
          sc.on_air_time = base_time + 7*i.days
          sc.span = span
          sc.weekday = (sc.on_air_time - 5.hours).wday

          next if OnAirSchedule.where("episode_id = ? AND medium_id = ? AND on_air_time = ?", sc.episode_id, sc.medium_id, sc.on_air_time).first.present?
          @schedules << sc
        end
      end
    elsif params[:commit].present?
      new_schedules = params[:schedule]

      OnAirSchedule.transaction do
        new_schedules.each do |new_schedule|
          episode = Episode.find_by_id(new_schedule[:epid].to_i)
          medium = Medium.find_by_id(new_schedule[:medium_id].to_i)
          on_air_time = Time.zone.parse(new_schedule[:on_air_time]) rescue nil
          span = new_schedule[:span].to_i
          raise "ダメ" if episode.blank? || medium.blank? || on_air_time.blank? || span <= 0
          sc = OnAirSchedule.new
          sc.episode_id = episode.id
          sc.anime_id = episode.anime_id
          sc.medium_id = medium.id
          sc.on_air_time = on_air_time
          sc.span = span
          sc.weekday = (on_air_time - 5.hours).wday

          raise if OnAirSchedule.where("episode_id = ? AND medium_id = ? AND on_air_time = ?", sc.episode_id, sc.medium_id, sc.on_air_time).first.present?
          sc.save!
        end
      end
      redirect_to :action => "schedule"
      return
    end
  end

  def schedule
    if request.post?
      sid = params[:id].to_i
      schedule = OnAirSchedule.find_by_id(sid)

      if params[:commit].present?
        on_air_time = Time.zone.parse(params[:date]) + params[:hour].to_i.hours + params[:min].to_i.minutes
        schedule.on_air_time = on_air_time
        schedule.weekday = (on_air_time - 5.hours).wday
        schedule.span = params[:span].to_i
        schedule.save!
      elsif params[:draft].present?
        schedule.status = 2
        schedule.save!
      elsif params[:open].present?
        schedule.status = 1
        schedule.save!
      end
      @schedules = OnAirSchedule.where("id = ?", schedule.id).page(1).per(20)
    else
      @schedules = OnAirSchedule.includes({:episode => [:anime]}, :medium).order("on_air_schedules.id DESC")
      if params[:q].present?
        @schedules = @schedules.where("animes.title = ?", params[:q])
      end

      if params[:aid].to_i > 0
        @schedules = @schedules.where("animes.id = ?", params[:aid].to_i)
      elsif params[:q].present?
        @schedules = @schedules.where("animes.title = ?", params[:q])
      end

      if params[:ep].present?
        @schedules = @schedules.where("episodes.episode = ?", params[:ep].to_i)
      end

      page = params[:pg].to_i > 0 ? params[:pg].to_i : 1
      @schedules = @schedules.page(page).per(50)
    end
  end

  def outside_site_list
    @sites = OutsideSite.all
  end

  def outside_site_register
    site = OutsideSite.new(:site_name => params[:site_name], :url => params[:url], :rss_url => params[:rss_url])
    unless site.valid?
      flash[:error_messages] = site.errors.messages
      redirect_to :action => "outside_site_list"
      return
    end

    site.save!
    redirect_to :action => "outside_site_list"
    return
  end

  def outside_site_status_change
    site = OutsideSite.where("id = ?", params[:outside_site_id].to_i).first
    if site.present?
      site.status = if params[:stop].present?
                      OutsideSite::Status::STOP
                    elsif params[:restart].present?
                      OutsideSite::Status::OPEN
                    end
      site.save!
    end
    redirect_to :action => "outside_site_list"
  end

  def outside_site_edit
    site = OutsideSite.where("id = ?", params[:outside_site_id].to_i).first
    raise if site.blank?

    site.site_name = params[:site_name]
    site.url       = params[:url]
    site.rss_url   = params[:rss_url]

    unless site.valid?
      flash[:error_messages] = site.errors.messages
      redirect_to :action => "outside_site_list"
      return
    end

    site.save!
    redirect_to :action => "outside_site_list"
    return
  end

  def account
    page = params[:page].present? ? params[:page].to_i : 1
    @users = User.page(page).per(20)
  end

  def account_edit
    @user = User.where(:id => params[:uid].to_i).first
    raise if @user.blank?

    @user.nickname = params[:nickname] if params[:nickname]
    @user.admin_status = params[:admin_status].to_i if params[:admin_status]
    @user.save!

    redirect_to :action => :account
  end

  def media_list
    @media_hash = Medium.all.group_by(&:area_to_sym)
  end

  def media_edit
    media = Medium.where(:id => params[:mid].to_i).first
    raise if media.blank?

    media.name = params[:name].to_s if params[:name].present?
    media.area_id = params[:area_id].to_i if params[:area_id].present?
    media.save!

    redirect_to :action => :media_list
  end

private
  def access_check
    redirect_to :controller => "anime", :action => "index" and return if @user.blank? || !@user.is_admin?
  end
end
