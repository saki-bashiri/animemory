class SummaryOperation
  include Rails.application.routes.url_helpers
  default_url_options[:host] = Rails.env.production? ? "animemory.jp" : "a-saki.krewmo.com"

  def initialize(anime, episode, summary, user, params={})
    if summary.present?
      @summary = summary
    else
      @anime = anime
      @episode = episode
      @thread = ThreadLog.where("id = ?", params[:tid].to_i).first
    end

    @title = params[:title]
    @description = params[:description]
    @twitter_post_flg = params[:twitter_post_flg].to_i == 1
    @user = user
    @params_contents = params[:summary]
  end

  def prepare
    all_image_ids = @params_contents.map{|h| h[:image_ids]}.flatten.map(&:to_i).uniq
    image_hash = AnimeImage.where("id IN (?)", all_image_ids).index_by(&:id)
    @summary_content_hashs = []
    @params_contents.each_with_index do |content, index|
      next unless content.is_a?(Hash)

      images = content[:image_ids].is_a?(Array) ? content[:image_ids].map{|id| image_hash[id.to_i]}.compact : []

      # 一番最初はmain_image, top_images のセットのみ
      if index == 0
        @main_image = images.shift
        @top_images = images
        next
      end

      text = content[:content].to_s
      @summary_content_hashs << {
        :content => text,
        :images => images,
        :anchor => content[:anchor].to_s,
        :post_cd => content[:post_cd].to_s,
        :posted_at => content[:posted_at].to_s,
        :name => content[:name].to_s}
    end

    @errors = []
    @errors <<  "まとめは100までにしてください" if @summary_content_hashs.size > 100
    [@main_image, @top_images, @summary_content_hashs, @errors]
  end

  def get_images_and_contents_hash
    return [] if @summary.blank?

    @summary_content_hashs = @summary.summary_contents.sort_by(&:sort).map do |summary_content|
      images = summary_content.sorted_anime_images
      {:content => summary_content.content,
       :images => images,
       :anchor => summary_content.anchor,
       :post_cd => summary_content.post_cd,
       :posted_at => summary_content.posted_at.try(:strftime, "%Y/%m/%d %H:%M:%S"),
       :name => summary_content.name}
    end

    @main_image = @summary.anime_image
    @top_images = AnimeImage.includes(:summary_images).where(
      "summary_images.summary_id = ? AND summary_images.summary_content_id IS NULL", @summary.id).order(
      "summary_images.image_sort ASC").all

    [@summary_content_hashs, @main_image, @top_images]
  end

  def commit!
    raise if @title.blank? || @summary_content_hashs.empty?
    summary = nil
    Summary.transaction do
      @summary = Summary.new
      @summary.user_id = @user.id
      @summary.title = @title
      @summary.description = @description
      @summary.thread_log_id = @thread.id
      @summary.anime_id = @anime.id
      @summary.episode_id = @episode.try(:id)
      @summary.anime_image_id = @main_image.try(:id)
      @summary.save!
      summary = @summary

      @top_images.each_with_index do |image, top_image_sort|
        summary_image = SummaryImage.new
        summary_image.summary_id = @summary.id
        summary_image.anime_image_id = image.id
        summary_image.image_sort = top_image_sort + 1
        summary_image.save!
      end

      commit_contents
    end
    twitter_post(twitter_text(@anime, @title, summary.id)) if @twitter_post_flg
    summary
  end

  def edit!
    raise if @title.blank? || @summary_content_hashs.empty?
    Summary.transaction do
      @summary.title = @title
      @summary.description = @description
      @summary.anime_image_id = @main_image.try(:id)
      @summary.save!

      SummaryContent.delete_all(["summary_id = ?", @summary.id])
      SummaryImage.delete_all(["summary_id = ?", @summary.id])

      @top_images.each_with_index do |image, top_image_sort|
        summary_image = SummaryImage.new
        summary_image.summary_id = @summary.id
        summary_image.anime_image_id = image.id
        summary_image.image_sort = top_image_sort + 1
        summary_image.save!
      end
      commit_contents
    end
  end

  def commit_contents
    @summary_content_hashs.each_with_index do |content, index|
      comment =SummaryContent.new
      comment.summary_id = @summary.id
      comment.sort = index + 1
      comment.content = content[:content]
      comment.anchor  = content[:anchor]
      comment.name    = content[:name]
      comment.posted_at = content[:posted_at].to_time rescue nil
      comment.post_cd   = content[:post_cd]
      comment.save!

      if !content[:images].empty?
        content[:images].each_with_index do |image, image_sort|
          summary_image = SummaryImage.new
          summary_image.summary_id = @summary.id
          summary_image.summary_content_id = comment.id
          summary_image.anime_image_id = image.id
          summary_image.image_sort = image_sort + 1
          summary_image.save!
        end
      end
    end
  end

  def twitter_post(text)
    Twitter.configure do |config|
      config.consumer_key =MasterTable::Twitter::BOT_CONSUMER_KEY
      config.consumer_secret = MasterTable::Twitter::BOT_CONSUMER_SECRET
      config.oauth_token     = MasterTable::Twitter::BOT_ACCESS_TOKEN
      config.oauth_token_secret = MasterTable::Twitter::BOT_ACCESS_TOKEN_SECRET
    end
    twitter_client = Twitter::Client.new
    twitter_client.update(text)
  end

  def twitter_text(anime, title, summary_id)
    "#{title} [#{anime.title}] #{url_for(:controller => 'summary', :action => 'index', :sid => summary_id, :aid => anime.id)}"
  end
end