class Comment < ActiveRecord::Base

  belongs_to :anime
  belongs_to :anime_thread
  belongs_to :user

  validates :comment, :presence => {:message => "コメントを入力してください。"},
                      :length => {:maximum => 2000, :message => "コメントは2000文字以内で入力してください。"}

end
