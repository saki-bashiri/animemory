class AnimeReport < ActiveRecord::Base

  belongs_to :anime
  belongs_to :anime_image

  attr_accessor :title

  MYPAGE_LIST_SIZE = 20

  module ReportType
    OTHER = 0
    ANIME_EDIT = 1
    SUMMARY_CREATE = 2

    KEYS = [:other, :anime_edit, :summary_create]
    NAMES = ["その他", "アニメ編集", "まとめ作成"]

    SENTENSE = {
      :anime_edit => "アニメ情報が編集されました",
      :summary_create => "まとめが作成されました"
    }

    class << self
      def type_to_sym(num)
        KEYS[num.to_i]
      end

      def type_num(sym)
        KEYS.index(sym).to_i
      end

      def sentense(sym)
        SENTENSE[sym]
      end
    end
  end

  module Target
    UNKNOWN = 0
    ANIME = 1
    EPISODE = 2
    SUMMARY = 3

    KEYS = [:unknown, :anime, :episode, :summary]

    MODELS = [nil, Anime, Episode, Summary]

    class << self
      def type_to_sym(num)
        KEYS[num.to_i]
      end

      def type_num(sym)
        KEYS.index(sym).to_i
      end

      def type_model(num)
        MODELS[num.to_i]
      end
    end
  end

  class << self
    def report_type_to_sym(num)
      ReportType.type_to_sym(num)
    end

    def report_type_num(sym)
      ReportType.type_num(sym)
    end

    def target_to_sym(num)
      Target.type_to_sym(num)
    end

    def target_num(sym)
      Target.type_num(sym)
    end

    def target_model(num)
      Target.type_model(num)
    end

    def report_sentense(sym)
      ReportType.sentense(sym)
    end

    def relational_models
      Target::KEYS.compact
    end

    def get_anirepo(user_id, offset = 0, limit = 20)
      reports = self.includes(:anime, :anime_image).
        joins("INNER JOIN mymemories on mymemories.anime_id = anime_reports.anime_id").
        where("mymemories.user_id = ?", user_id).order("reported_on DESC").offset(offset).limit(limit)

      reports.group_by(&:target).each do |target, target_reports|
        target_hash = target_model(target).where(:id => target_reports.map(&:target_id)).index_by(&:id)

        target_reports.each do |report|
          object = target_hash[report.target_id]
          next if object.blank?
          report.title = object.title # Anime, Episode, Summary のtitleカラムがあること前提
          # report.url   =  # ここでセットするようにしたい
        end
      end
      reports
    end

    def create_anirepo(anime_id, target, report_type)
      anirepo = self.new
      anirepo.anime_id = anime_id
      anirepo.report_type = report_type_num(report_type)
      anirepo.target = target_num(target.class.name.downcase.to_sym)
      anirepo.target_id = target.id
      anirepo.anime_image_id = target.anime_image.try(:id)
      anirepo.reported_on = Time.now
      anirepo.save!
    end
  end

  def report_type_to_sym
    self.class.report_type_to_sym(report_type)
  end

  def target_to_sym
    self.class.target_to_sym(target)
  end

  def report_sentense
    self.class.report_sentense(report_type_to_sym)
  end

  def url_options
    case target_to_sym
    when :anime then {:controller => :anime, :action => :dtl, :anime => anime_id}
    when :episode then {:controller => :anime, :action => :dtl, :anime => anime_id, :epid => target_id}
    when :summary then {:controller => :summary, :action => :index, :sid => target_id, :aid => anime_id}
    else {}
    end
  end
end
