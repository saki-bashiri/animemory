class AnimeThread < ActiveRecord::Base

  belongs_to :anime
  belongs_to :user
  belongs_to :episode
  has_many :comments

  validates :title, :presence => {:message => "タイトルを入力してください。"},
                     :length => {:maximum => 100, :message => "タイトルは100文字以内にしてください。"}

  OPEN   = 1
  DELETE = 99

end
