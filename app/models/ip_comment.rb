class IpComment < ActiveRecord::Base
  belongs_to :episode
  belongs_to :anime
end
