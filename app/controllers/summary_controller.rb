class SummaryController < ApplicationController
  before_filter :login_check, :only => [:thread_lst, :register, :registering, :edit, :editing]
  before_filter :redirect_smartphone, :only => [:index]
  protect_from_forgery

  def index
    summary_id = params[:sid].to_i
    @summary  = Summary.includes({:summary_contents => :anime_images}, :anime_image, :anime).
      where("summaries.id = ?", summary_id).where("animes.status = ?", Anime::Status::ACTIVE).first
    @new_summaries      = Summary.where("summaries.id <> ?", @summary.id).order("created_at DESC").limit(5)
    
    outside_summaries = OutsideSummary.open_outside_summaries.order("posted_at DESC").limit(20)
    @outside_summaries_left, @outside_summaries_right = outside_summaries.each_slice(10).to_a
    @summary_comments = SummaryComment.includes(:summary_content).where(:summary_id => @summary.id).order("comment_number ASC").all
    @summary_res_comment_hash = @summary_comments.select{|comment| comment.summary_content_id.present?}.group_by(&:summary_content_id)

    @mymemory = Mymemory.where(:anime_id => @summary.anime.id, :user_id => @user.id).first if @user.present?
    @amazon_products = @summary.anime.amazon_products
  end

  def thread_lst
    if params[:epid].present?
      @episode = Episode.includes(:anime).where("episodes.id = ?", params[:epid].to_i).first
      raise if @episode.blank?
      @anime = @episode.anime
    else
      @anime = Anime.where("id = ?", params[:aid].to_i).first
      raise if @anime.blank?
    end

    includes = [:board]
    if params[:q].present?
      conds = ["thread_logs.subject like ?", "%#{params[:q].to_s}%"]
      if params[:more].present?
        limit_time = Time.zone.now - 3.days
        conds[0] += " OR (thread_logs.updated_at > ? AND thread_responses.content like ?)"
        conds << limit_time
        conds << "%#{params[:q].to_s}%"
        includes << :thread_responses
      end
    end

    @threads = ThreadLog.includes(includes).where(conds).order("thread_logs.updated_at DESC")
  end

  def register
    limit_time = Time.zone.now - 1.day
    if params[:epid].present?
      @episode = Episode.includes({:anime => :anime_images}).where("id = ?", params[:epid].to_i).first
      raise if @episode.blank?
      @anime = @episode.anime
      @anime_images = @anime.anime_images.delete_if{|anime_img| anime_img.created_at < limit_time}
    else
      @anime = Anime.includes(:anime_images).where("id = ?", params[:aid].to_i).first
      @anime_images = @anime.anime_images.delete_if{|anime_img| anime_img.created_at < limit_time}
      raise if @anime.blank?
    end

    @thread = ThreadLog.includes(:thread_responses).where("dat_cd = ?", params[:dat_cd]).first
    raise if @thread.blank?
  end

  def ajax_image_refresh
    limit_time = Time.zone.now - 1.day

    anime_images = AnimeImage.where("anime_id = ? AND status = ? AND created_at > ?", params[:aid].to_i, AnimeImage::Status::OPEN, limit_time)

    render :partial => "summary/image_box", :locals => {:anime_images => anime_images}
  end

  def registering
    redirect_to :controller => "anime", :action => "index" and return if !request.post?
    if params[:epid].present?
      @episode = Episode.includes({:anime => :anime_images}).where("id = ?", params[:epid].to_i).first
      raise if @episode.blank?
      @anime = @episode.anime
    else
      @anime = Anime.includes(:anime_images).where("id = ?", params[:aid].to_i).first
      raise if @anime.blank?
    end
    @title = params[:title].to_s
    @description = params[:description].to_s
    @thread = ThreadLog.where("id = ?", params[:tid].to_i).first
    @twitter_post_flg = params[:twitter_post_flg].to_i == 1

    raise if !params[:summary].is_a?(Array)

    summary_operation = SummaryOperation.new(@anime, @episode, nil, @user, params)

    @main_image, @top_images, @summary_contents, @errors = summary_operation.prepare

    render :action => "register" and return if @errors.present?

    if params[:back].present?
      render :action => "register"
      return
    end

    if params[:commit].present?
      summary = summary_operation.commit!
      redirect_to :action => "index", :sid => summary.id
    end
  end

  def edit
    @summary = Summary.includes([:summary_contents, {:anime => [:anime_images]}, :thread_log, :anime_image]).where("id = ? and user_id = ?", params[:sid].to_s.to_i, @user.id).first
    raise "不正な遷移です。" if @summary.blank?
    @episode = @summary.episode
    @anime = @summary.anime
    @thread = @summary.thread_log
    @title = @summary.title
    @description = @summary.description

    summary_operation = SummaryOperation.new(nil, nil, @summary, @user)
    @summary_contents, @main_image, @top_images = summary_operation.get_images_and_contents_hash
    render "register"
  end

  def editing
    redirect_to :controller => "anime", :action => "index" and return if !request.post?
    @summary = Summary.includes([:anime, :episode, :thread_log]).where("summaries.id = ? and summaries.user_id = ?", params[:sid].to_s.to_i, @user.id).first
    raise "不正な遷移です" if @summary.blank?

    @episode = @summary.episode
    @anime = @summary.anime
    raise if !params[:summary].is_a?(Array)
    @thread = @summary.thread_log
    @title = params[:title].to_s
    @description = params[:description].to_s

    summary_operation = SummaryOperation.new(nil, nil, @summary, @user, params)
    @main_image, @top_images, @summary_contents, @errors = summary_operation.prepare

    if params[:back].present?
      render :action => "register"
      return
    end

    if params[:commit].present?
      summary_operation.edit!

      redirect_to :action => "index", :sid => @summary.id
      return
    end
    render "registering"
  end

  def summary_howto

  end

  def comment_post
    summary, content = transact_comment(params[:sid], params[:content_id], params[:content])
    redirect_to :action => "index", :sid => summary.id, :aid => summary.anime_id
  end

  def ajax_post_summary_comments
    summary, content = transact_comment(params[:summary_id], params[:content_id], params[:content])
    render :partial => "each_comment_box", :locals => {:res => content, :summary => summary, :comments => content.sorted_comments}
  end

  private

  def login_check
    redirect_to :controller => "account", :action => "login" if @user.blank?
  end

  def redirect_smartphone
    ua = request.env["HTTP_USER_AGENT"].inspect
    redirect_to :controller => "smartphone", :action => "summary_index", :sid => params[:sid] if (ua.include?('Mobile') || ua.include?('Android'))
  end
  
  def transact_comment(summary_id, content_id, content)
    summary = Summary.includes(:summary_contents, :summary_comments).where("summaries.id = ?", summary_id.to_i).first
    max_res_count = SummaryComment.where("summary_id = ?", summary.id).maximum("comment_number").to_i
    comment = SummaryComment.new(:summary_id => summary.id, :comment_number => (max_res_count + 1), :content => content.to_s)
    comment.summary_id = summary.id
    if content = SummaryContent.where("id = ?", content_id.to_i).first
      sort_num = SummaryComment.where("summary_content_id = ?", content.id).maximum("content_res_number").to_i
      comment.summary_content_id = content.id
      comment.content_res_number = sort_num + 1
    end
    comment.save!
    [summary, content]
  end

end
