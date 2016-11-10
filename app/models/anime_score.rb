class AnimeScore < ActiveRecord::Base
  attr_accessible :anime_id, :favorite_count, :watching_count, :watched_count
end
