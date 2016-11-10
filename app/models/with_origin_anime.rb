class WithOriginAnime < ActiveRecord::Base
  belongs_to :anime
  belongs_to :origin
end
