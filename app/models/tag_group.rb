class TagGroup < ActiveRecord::Base
  attr_accessible :tag_id, :anime_id

  belongs_to :anime
  belongs_to :tag
end
