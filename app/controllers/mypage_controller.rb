class MypageController < ApplicationController
  before_filter :auth
  ANIREPO_SIZE = AnimeReport::MYPAGE_LIST_SIZE

  #verify :method => :post, :xhr => true, :only => [:anirepo_ajax, :media_select, :ajax_my_channel]

  before_filter :get_notice_and_update, :only => [:notice]
  before_filter :count_notice

  VOICE_ACTOR_NAMES = %W| 花澤香菜 水樹奈々 沢城みゆき 小倉唯 田村ゆかり 釘宮理恵 東山奈央 戸松遥 竹達彩奈 豊崎愛生
    神谷浩史 鈴木達央 梶裕貴 杉田智和 小野大輔 宮野真守 福山潤 下野紘 中村悠一 鈴村健一 |

  PRODUCTION_NAMES = %W| 京都アニメーション シャフト Production\ I.G ufotable A-1\ Pictures P.A.WORKS J.C.STAFF GAINAX
    スタジオカラー Ordet TRIGGER SILVER\ LINK. マングローブ |

  # タイムライン
  def index
    today_anime_time = AnimeTime.start_time
    @watching_rank_animes = Anime.includes(:anime_image, :anime_score).
      where("animes.status = ?", Anime::Status::ACTIVE).order("anime_scores.watching_count DESC").limit(10)
    @today_schedule_hash = OnAirSchedule.get_daily_schedule(@user.id, today_anime_time)

    anime_ids = (@watching_rank_animes.map(&:id) + @today_schedule_hash.values.flatten.map(&:anime_id)).uniq

    schedule_epids = @today_schedule_hash.values.flatten.map(&:episode_id).uniq
    @episode_memory_hash = EpisodeMemory.where(:user_id => @user.id, :episode_id => schedule_epids).all.index_by(&:episode_id)
    @mymemory_hash = Mymemory.where(:user_id => @user.id, :anime_id => anime_ids).
      all.index_by(&:anime_id)
  end

  def anirepo_ajax
    offset = params[:offset].to_i
    anirepos = AnimeReport.get_anirepo(@user.id, offset, ANIREPO_SIZE)
    render :partial => "anirepo_list_group", :locals => {:anirepos => anirepos, :offset => (offset + 1)}
  end

  # お気に入りアニメ一覧
  def favo
    @mymemories = Mymemory.includes({:anime => [:anime_image]}).where(:user_id => @user.id, :favorite_flg => true).all
  end

  def watching
    @mymemories = Mymemory.includes({:anime => [:anime_image]}).
      where(:user_id => @user.id, :watch_status => Mymemory.watch_status_num(:watching)).
      order("favorite_flg DESC").all
  end

  def watched
    @mymemories = Mymemory.includes({:anime => [:anime_image]}).
      where(:user_id => @user.id, :watch_status => Mymemory.watch_status_num(:watched)).
      order("favorite_flg DESC").all
  end

  def media_list
    @media_hash = Medium.all.group_by(&:area_to_sym)
    @user_media_ids = UserMedium.where(:user_id => @user.id).select("medium_id").all.map(&:medium_id)
    @new_register_flg = !!session[:new_register]
  end

  def media_select
    raise if !request.xhr?
    type = params[:type] == "select" ? :select : :delete
    media = Medium.where(:id => params[:mid].to_i).first
    raise if media.blank?

    user_media = UserMedium.where(:user_id => @user.id, :medium_id => media.id).first

    if type == :delete && user_media.present?
      user_media.destroy
    elsif type == :select && user_media.blank?
      user_media = UserMedium.new
      user_media.user_id = @user.id
      user_media.medium_id = media.id
      user_media.save!
    end

    render :json => {:type => (type == :select ? "selected" : "deleted" )}.to_json
  end

  def intro_mychannel
    @voice_actors = Creator.where(:name => VOICE_ACTOR_NAMES).all
    @productions = Creator.where(:name => PRODUCTION_NAMES).all
    crids = @voice_actors.map(&:id) | @productions.map(&:id)
    @mychannel_crids = MyChannel.where(:user_id => @user.id, :creator_id => crids).select("creator_id").map(&:creator_id)
    session[:new_register] = nil
  end

  def can_watch
    today_time = AnimeTime.start_time
    media_ids = UserMedium.where(:user_id => @user.id).select("medium_id").all.map(&:medium_id)

    @anime_media_relation = OnAirSchedule.includes(:medium, :anime).
      where("on_air_schedules.medium_id IN (?)", media_ids).
      where("on_air_schedules.on_air_time BETWEEN ? AND ?", today_time, today_time + 7.days).
      where("animes.status = ?", Anime::Status::ACTIVE).all.
      each_with_object({}) do |schedule, hash|
        hash[schedule.anime_id] ||= []
        hash[schedule.anime_id] << schedule.medium if !hash[schedule.anime_id].any?{|media| media.id == schedule.medium.id}
      end
    @animes = Anime.includes(:anime_image).where(:id => @anime_media_relation.keys).all
    mymemory_hash = Mymemory.where(:user_id => @user.id, :anime_id => @animes.map(&:id)).all.index_by(&:anime_id)
    @mymemory_by_anime = @animes.each_with_object({}) do |anime, hash|
      if ( mymemory = mymemory_hash[anime.id] ).blank?
        mymemory = Mymemory.new
        mymemory.user_id = @user.id
        mymemory.anime_id = anime.id
      end
      hash[anime.id] = mymemory
    end
  end

  def notice
    @channel_creators = Creator.includes(:my_channels).where("my_channels.user_id = ?", @user.id)
  end

  def my_channel
    channel_cids = MyChannel.where(:user_id => @user.id).select("creator_id").map(&:creator_id)
    @creators = Creator.where(:id => channel_cids)
  end

  def ajax_my_channel
    creators = Creator.where("creators.name like ?", "%#{params[:q]}%")
    if params[:label].present? && CreatorLabel::KEYS.include?(params[:label].to_sym)
      creators = creators.where_label_types(params[:label].to_sym)
    end

    mychannel_cids = MyChannel.where(:user_id => @user.id, :creator_id => creators.map(&:id)).select("creator_id").all.map(&:creator_id)
    render :partial => "my_channel_list_group", :locals => {:creators => creators, :mychannel_cids => mychannel_cids, :user => @user}
  end

  def initial_setting
    @recommend_media = Medium.recommend_media_group
    @user_media_ids = UserMedium.where(:user_id => @user.id).select("medium_id").all.map(&:medium_id)

    @animes = Anime.order("id desc").limit(30)
    @mymemories = Mymemory.where(:user_id => @user.id).all

    @voice_actors = Creator.where(:name => VOICE_ACTOR_NAMES).all
    @productions = Creator.where(:name => PRODUCTION_NAMES).all
    crids = @voice_actors.map(&:id) | @productions.map(&:id)
    @mychannel_crids = MyChannel.where(:user_id => @user.id, :creator_id => crids).select("creator_id").map(&:creator_id)
  end

  private

  def get_notice_and_update
    @creator_ids = MyChannel.where(:user_id => @user.id).select("creator_id").all.map(&:creator_id)
    page = params[:pg].to_i > 0 ? params[:pg].to_i : 1
    @notifications = ChannelNotification.includes({:anime => :anime_image}, :creator, :staff, {:song_artist => :song}, :character).
      where(:creator_id => @creator_ids)

    @selected_creator = Creator.where(:id => params[:crid].to_i).first if params[:crid].to_i > 0
    @notifications = @notifications.where(:creator_id => @selected_creator.id) if @selected_creator

    @notifications = @notifications.order("channel_notifications.created_at DESC").page(page).per(20)

    notice_ids = @notifications.select{|ntf| ntf.new?}.map(&:id)
    @new_notice_ids = notice_ids - ReadChannelNotification.where(:user_id => @user.id).select("channel_notification_id").map(&:channel_notification_id)
    ReadChannelNotification.transaction do
      @new_notice_ids.each{|notice_id| ReadChannelNotification.create!(:user_id => @user.id, :channel_notification_id => notice_id)}
    end
  end

  def count_notice
    @creator_ids ||= MyChannel.where(:user_id => @user.id).select("creator_id").all.map(&:creator_id)
    notice_ids = ChannelNotification.where_new_notice.where(:creator_id => @creator_ids).select("id").map(&:id)
    @notice_size = ( notice_ids - ReadChannelNotification.where(:user_id => @user.id).map(&:channel_notification_id) ).size
  end
end
