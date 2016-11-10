class Production < ActiveRecord::Base
  belongs_to :anime
  has_many :production_revisions
end
