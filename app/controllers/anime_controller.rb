class AnimeController < ApplicationController
  before_filter :redirect_mypage, :only => [:index]
  before_filter :auth, :only => [:edit, :edit_conf, :main_image_edit]

  RANK_SIZE = 7
  TOP_RANK_SIZE = 7

  def index
    today = Date.today
    @current_animes = Anime.includes(:anime_image).where("status = ?", Anime::Status::ACTIVE).where("started_on IS NOT NULL").
      where("finish_flg = false").where("finished_on IS NULL OR finished_on >= ?", today).all
    @top_watching_animes = Anime.includes(:anime_image, :anime_score).order("anime_scores.watching_count DESC").limit(7)
  end

  def list
    word = params[:q].to_s.gsub(/\\/, "\\\\").gsub(/%/, "\\%").gsub(/_/, "\\_").gsub(/(\s|　)/, "")
    if word.jlength > 200
      flash[:notice] = "キーワードが長すぎます。"
      redirect_to :action => "index"
      return
    end
    key = params[:search_key].to_s
    page = params[:pg].to_i > 0 ? params[:pg].to_i : 1
    order = "animes.title ASC"
    @animes = Anime.where("animes.status = ?", 1)
    case
    when key.present? && key == "tag"
      @animes = @animes.includes(:tags).where("tags.name like ?", "%#{word}%").order(order).page(page).per(20)
    when key.present? && key == "cv"
      @animes = @animes.includes(:tags, {:characters => [:creator]}).where("creators.name like ?", "%#{word}%").order(order).page(page).per(20)
    else
      @animes = @animes.includes(:tags).where("status = ?", 1).where("animes.title like ? or animes.kana like ? ", "%#{word}%", "%#{word}%").order(order).page(page).per(20)
    end

    @mymemory_hash = @user.present? ? Mymemory.where(:anime_id => @animes.map(&:id), :user_id => @user.id ).index_by(&:anime_id) : {}
    #@amazon_products = AmazonProduct.where(:lst_ad_flg => true).limit(5)
  end
  
  def dtl
    include_option = [:episodes, :tags, :anime_image, :anime_score, {:characters => :creator}, {:staffs => [:creator, :role]}, {:songs => {:song_artists => {:creator => [:creators]} } }]
    @anime = Anime.where("id = ? AND status = ?",params[:anime].to_i, 1).includes(include_option).first
    raise ActiveRecord::RecordNotFound, "指定のアニメが見つかりません。" if @anime.blank?

    @anime_main_image = @anime.anime_image

    @favorites = Mymemory.includes(:user).where(:favorite_flg => true, :anime_id => @anime.id).all
    @watchings = Mymemory.includes(:user).where(:watch_status => Mymemory::WatchStatus::WATCHING, :anime_id => @anime.id).all
    @watched_count = @anime.anime_score.watched_count
    @mymemory = Mymemory.where_or_new(@user.try(:id), @anime.id)
    @episode_memory_hash = @user.present? ? EpisodeMemory.where(:anime_id => @anime.id, :user_id => @user.id).all.index_by(&:episode_id) : {}

    @creators = @anime.creators + @anime.characters.map(&:creator) + @anime.songs.map(&:creators)
    @my_channel_creator_ids = MyChannel.where(:user_id => @user.try(:id), :creator_id => @creators.map(&:id).uniq).all.map(&:creator_id)
  end
  
  def add_tag
    raise "不正な遷移です。" if !request.post? || params[:anime].blank?
    anime = Anime.where("id = ?", params[:anime].to_i).first
    raise ActiveRecord::RecordNotFound, "タグを登録するアニメが見つかりません。" if anime.blank?

    new_tag = params[:tag].to_s.gsub(/(\s|　|\t|\r|\n)/, "")
    redirect_to :action => "dtl", :anime => anime.id and flash[:alert] = "タグ名が不適当です。" and return if new_tag.blank? || new_tag.jlength > Tag::MAX_LENGTH
    Tag.transaction do
      tag = Tag.find_or_create_by_name(new_tag)
      redirect_to :action => "dtl", :anime => anime.id and flash[:alert] = "既に存在するタグです。" and return if TagGroup.where("anime_id = ? and tag_id = ?", anime.id, tag.id).first.present?
      tag_group = TagGroup.new
      tag_group.anime_id = anime.id
      tag_group.tag_id = tag.id
      tag_group.save!
    end

    redirect_to :action => "dtl", :anime => anime.id
    return
  end

  def remove_tag
    raise "不正な遷移です。" unless request.post?
    tag_id = params[:tag_id].to_i
    anime_id = params[:anime_id].to_i
    anime = Anime.where(:id => anime_id).first
    TagGroup.transaction do
      tag_group = TagGroup.where("tag_id = ? and anime_id = ?", tag_id, anime.id)
      raise ActiveRecord::RecordNotFound, "指定のタグが見つかりません。" if tag_group.blank?
      tag_group.map{|tag_link| tag_link.destroy}
    end
    redirect_to :action => "dtl", :anime => anime.id
    return
  end

  def edit
    @anime = Anime.where(:id => params[:aid].to_i).first
    raise ActiveRecord::RecordNotFound unless @anime
    @anime.outline = flash[:outline] if flash[:outline].present?
  end

  def edit_conf
    @anime = Anime.where(:id => params[:aid].to_i).first
    raise ActiveRecord::RecordNotFound unless @anime

    @anime.outline = params[:outline].to_s
  end

  def edit_do
    @anime = Anime.where(:id => params[:aid].to_i).first
    raise ActiveRecord::RecordNotFound unless @anime

    if params[:back].present?
      flash[:outline] = params[:outline]
      redirect_to :action => :edit, :aid => @anime.id
      return
    end

    @anime.update_outline!(params[:outline].to_s)
    redirect_to :action => :dtl, :anime => @anime.id
  end

  def images
    @anime = Anime.where("id = ?", params[:aid].to_i).where("animes.status = ?", 1).first
    raise ActiveRecord::RecordNotFound, "アニメがありません。" if @anime.blank?

    @images = AnimeImage.where("status = ?", AnimeImage::OPEN).where("anime_id = ?", @anime.id)
  end

  def image_up
    redirect_to :controller => "account", :action => "auth_twitter" and return if @user.blank?
    @anime = Anime.where("id = ?", params[:aid].to_i).where("animes.status = ?", 1).where_valid.first
    redirect_to :action => "index" and return if @anime.blank?
    @user_images = AnimeImage.where("status = ?", AnimeImage::OPEN).where("anime_id = ? AND user_id = ?", @anime.id, @user.id)
  end

  def main_image_edit
    @anime = Anime.includes(:anime_images, :anime_image).where(:id => params[:aid].to_i).where_valid.first
  end

  def main_image_edit_do
    anime = Anime.includes(:anime_image).where(:id => params[:aid].to_i).where_valid.first
    raise AnimemoryError, "不正な遷移です" unless anime
    anime.update_main_image!(params[:image_id].to_i)
    redirect_to :action => :dtl, :anime => anime.id
  end

private

  def redirect_mypage
    redirect_to :controller => :mypage, :action => :index if @user.present?
    return false
  end
end
