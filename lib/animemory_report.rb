class AnimemoryReport
  attr_accessor :report_type, :reported_on, :title, :url_options, :image

  module ReportType
    UNKNOWN = 0
    ANIME_EDIT = 1
    SUMMARY_CREATE = 2

    KEYS = [:unknown, :anime_edit, :summary_create]

    REPORT_SENTENSE = {
      :anime_edit => "アニメが編集されました",
      :summary_create => "まとめが作成されました"
    }
  end

  class << self
    def get_all_reports
      summaries = Summary.includes(:anime_image).order("summaries.created_at DESC").limit(20)
      anime_histories = AnimeHistory.includes(:anime_image).order("anime_histories.created_at DESC").limit(20)

      reports = []
      summaries.each do |summary|
        url_options = {:controller => :summary, :action => :index, :sid => summary.id, :aid => summary.anime_id}
        reports << self.new(:summary_create, summary.created_at, summary.title, url_options, summary.anime_image)
      end

      anime_histories.each do |anime_history|
        url_options = {:controller => :anime, :actiion => :dtl, :anime => anime_history.anime_id}
        reports << self.new(:anime_edit, anime_history.created_at, anime_history.title, url_options, anime_history.anime_image)
      end

      reports
    end
  end

  def initialize(report_type, reported_on, title, url_options, image = nil)
    @report_type = report_type
    @reported_on = reported_on
    @title = title
    @url_options = url_options
    @image = image
  end

  def report_sentense
    ReportType::REPORT_SENTENSE[@report_type]
  end
end