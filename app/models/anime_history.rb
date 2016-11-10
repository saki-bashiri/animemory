class AnimeHistory < ActiveRecord::Base
  belongs_to :user
  belongs_to :anime
  has_one :anime_main_image_revision
  has_one :anime_image, :through => :anime_main_image_revision

  validates :comment, :presence => {:message => "コメントを記入してください。"},
                       :length => { :maximum => 200, :message => "200文字以内で入力してください。"}

end
