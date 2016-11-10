class MyChannel < ActiveRecord::Base
  attr_accessible :user_id, :creator_id

  belongs_to :user
  belongs_to :creator

  class CreatorType
    ALL = 0
    VOICE_ACTOR = 1
    STAFF = 2
    PRODUCTION = 3
    SINGER = 4
    SONGWRITER = 5
    COMPOSER = 6

    KEY = {ALL => :all, VOICE_ACTOR => :voice_actor}


    def initialize(creator_type)
    end
  end

  class << self
    def where_creator_type(creator_type)
    end
  end
end