class AnimeMainImage < ActiveRecord::Base
  attr_accessible :anime_id, :anime_image_id

  belongs_to :anime
  belongs_to :anime_image
end
