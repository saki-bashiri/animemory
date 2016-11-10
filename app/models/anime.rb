class Anime < ActiveRecord::Base

  attr_accessor :debug, :image, :ep_cnt, :admin_operation
  attr_accessible :title, :kana, :outline, :started_on, :finished_on, :total_episode, :movie_flg, :status,
                  :production_id, :shoboi_tid
  after_create :create_anime_score

  has_many :tag_groups
  has_many :tags, :through => :tag_groups
  has_many :episodes
  has_many :anime_threads
  has_many :comments
  has_many :on_air_schedules
  has_one  :with_origin_anime
  has_one  :origin, :through => :with_origin_anime
  has_many :characters, :conditions => ["characters.status = ?", 1]
  has_many :songs
  has_many :mymemories
  has_many :anime_histories
  has_many :staffs
  has_many :creators, :through => :staffs
  has_many :roles, :through => :staffs
  has_many :ip_comments
  has_many :anime_images, :conditions => "anime_images.status = #{AnimeImage::OPEN}"
  has_many :anime_amazon_advertises
  has_many :amazon_products, :through => :anime_amazon_advertises

  has_one :anime_main_image
  has_one :anime_image, :through => :anime_main_image
  has_one :anime_score

  validates :title, :presence => {:message => "タイトルを入力して下さい。"},
                     :length => {:maximum => 200, :message => "タイトルは200文字以内で入力ください。"},
                     :uniqueness => {:message => "同じタイトルが既に存在します。" }
  validates :kana, :presence => {:message => "かなを入力して下さい。"},
                    :length => {:maximum => 200, :message => "かなは200文字以内で入力ください。"},
                    :format => {:with => /^[あ-んーぁぃぅぇぉっゔヴ]+$/, :message => "かなは空白等を入れず、全てひらがなで入力してください。" }
  validates :outline, :length => {:maximum => 5000, :message => "アニメモは5000文字以内で入力ください。"}

  # あとでリファクタリング
  ACTIVE = 1
  DRAFT  = 2
  DELETE = 99
  STATUS = {
   ACTIVE => "掲載中",
   DRAFT  => "保留中",
   DELETE => "削除済み"
  }

  module Status
    ACTIVE = 1
    DRAFT  = 2
    DELETE = 99
    NAME = {
      ACTIVE => "掲載中",
      DRAFT => "保留中",
      DELETE => "削除済み"
    }
  end

  def validate
    errors.on(:title, "同じタイトルのアニメが存在します") if Anime.where("title = BINARY(?)", self.title).first.present?
  end

  def update_outline!(outline)
    self.outline = outline
    self.save!
  end

  def update_main_image!(image_id)
    image = AnimeImage.where(:anime_id => self.id, :id => image_id).first
    raise AnimemoryError, "画像が見つかりません" unless image
    main_image = self.anime_main_image || AnimeMainImage.new(:anime_id => self.id)
    main_image.anime_image_id = image.id
    main_image.save!
  end

  def set_attributes(params, user, revision = AnimeHistory.new, options={})
    self.title       = params[:title].to_s.gsub(/(\t|\r|\n)/, "").gsub(/　/, "\s")
    self.kana        = params[:kana].to_s
    self.outline     = params[:outline].to_s
    self.started_on  = Date.parse(params[:started_on].to_s) rescue nil
    self.finished_on = Date.parse(params[:finished_on].to_s) rescue nil
    self.movie_flg   = params[:movie_flg] ? true : false
    self.status      = params[:status].to_i if user.present? && user.is_admin? && params[:status].present?
    self.shoboi_tid  = params[:shoboi_tid].to_i if user.present? && user.is_admin? && params[:status].present?

    @image = AnimeImage.where("id = ? AND anime_id = ? AND status = ? AND draft_flg = ?",
                              params[:image].to_i, self.id, AnimeImage::OPEN, false).first if params[:image].to_i > 0 && !self.new_record?
    @user = user
    @revision = revision
    @revision_comment = params[:comment].to_s

    @is_admin = true if options[:is_admin]
  end

  def songs_by_type
    songs = self.songs
    result = {}
    result[:op] = songs.select{|song| song.op?}
    result[:ed] = songs.select{|song| song.ed?}
    result[:featured] = songs.select{|song| song.featured?}
    result
  end

  class << self
    def where_valid
      self.where(:status => Status::ACTIVE)
    end
  end

  private

  def create_anime_score
    AnimeScore.create!(:anime_id => self.id)
  end
end
