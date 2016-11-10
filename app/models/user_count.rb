class UserCount < ActiveRecord::Base
  attr_accessible :user_id, :favorite_count, :watching_count, :watched_count
  belongs_to :user
end
