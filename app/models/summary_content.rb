class SummaryContent < ActiveRecord::Base
  belongs_to :summary
  has_many :summary_images
  has_many :anime_images, :through => :summary_images
  has_many :summary_comments
  validates :content, :presence => {:message => "内容を入力して下さい。"},
            :length => {:maximum => 5000, :message => "5000文字以内で入力ください。"}

  def sorted_anime_images
    summary_images = self.summary_images.sort_by(&:image_sort)
    summary_images.map(&:anime_image)
  end

  def sorted_comments
    self.summary_comments.sort_by(&:content_res_number)
  end
end
