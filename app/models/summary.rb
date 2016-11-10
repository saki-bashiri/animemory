class Summary < ActiveRecord::Base
  belongs_to :anime_image
  belongs_to :thread_log
  has_many :summary_contents
  belongs_to :user
  belongs_to :anime
  belongs_to :episode
  has_many :summary_images
  has_many :anime_images, :through => :summary_images, :conditions => "summary_images.summary_content_id IS NULL"
  has_many :summary_responses
  has_many :summary_comments

  validates :title, :presence => {:message => "タイトルを入力して下さい。"},
            :length => {:maximum => 200, :message => "タイトルは200文字以内で入力ください。"}

  after_create :create_anirepo

  def sorted_anime_images
    top_images = summary_images.select{|simg| simg.summary_content_id.blank?}.sort_by(&:image_sort).map(&:anime_image)
  end

  def sorted_contents
    return @sorted_summary_contents if defined?(@sorted_summary_contents)
    @sorted_summary_contents = self.summary_contents.sort_by(&:sort)
  end

  def sorted_comments
    return @sorted_comments if defined?(@sorted_comments)
    @sorted_comments = self.summary_comments.sort_by(&:comment_number)
  end

  private

  def create_anirepo
    AnimeReport.create_anirepo(self.anime_id, self, :summary_create)
  end
end
