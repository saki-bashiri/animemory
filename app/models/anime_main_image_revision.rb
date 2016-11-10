class AnimeMainImageRevision < ActiveRecord::Base
  belongs_to :anime_image
  belongs_to :anime_history
end
