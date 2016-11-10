class User < ActiveRecord::Base
  has_many :anime_histories
  has_one :user_count
  has_one :user_info
  has_many :my_channels

  after_create :create_user_count

  NORMAL = 1
  ADMIN = 2
  QUIT = 99

  ADMIN_USERS = [4, 9]

  module AdminStatus
    NOT_ADMIN = 0
    ADMIN     = 1
    NAME = {
      :not_admin => "権限なし",
      :admin     => "管理者"
    }

    KEYS = [:not_admin, :admin]
  end

  module RegisterType
    ANIMEMORY = 1
    TWITTER = 2
  end

  module Status
    NORMAL = 1
    ADMIN = 2
    QUIT = 99
  end

  def admin_status_to_sym
    AdminStatus::KEYS[admin_status]
  end

  def admin_status_name
    AdminStatus::NAME[admin_status_to_sym]
  end

  def is_admin?
    admin_status_to_sym == :admin || Rails.env.development?
  end

  def twitter_post(text, twitter_token, twitter_secret)
    return false if twitter_token.blank? || twitter_secret.blank?

    Twitter.configure do |config|
      config.consumer_key       = MasterTable::Twitter::CONSUMER_KEY
      config.consumer_secret    = MasterTable::Twitter::CONSUMER_SECRET
      config.oauth_token        = twitter_token
      config.oauth_token_secret = twitter_secret
    end
    twitter_client = Twitter::Client.new
    twitter_client.update(text)
  end

  def update_profile_image(profile_image_url, profile_background_image_url)
    if profile_image_url.present? && self.profile_image_url != profile_image_url
      self.profile_image_url = profile_image_url
    end

    if profile_background_image_url.present? && self.profile_background_image_url != profile_background_image_url
      self.profile_background_image_url = profile_background_image_url
    end

    self.save! if self.changed?
  end

  private

  def create_user_count
    return if UserCount.where(:user_id => self.id).first

    UserCount.create!(:user_id => self.id)
  end
end
