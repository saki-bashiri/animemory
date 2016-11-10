class OutsideSite < ActiveRecord::Base
  attr_accessible :rss_url, :site_name, :status, :url
  validates :site_name, :presence => {:message => "名前を入力して下さい。"},
            :length => {:maximum => 255, :message => "255文字以内で入力ください。"},
            :uniqueness => {:message => "既に登録済みです"}
  validates :url, :presence => {:message => "URLを入力して下さい。"},
            :length => {:maximum => 255, :message => "255文字以内で入力ください。"},
            :uniqueness => {:message => "既に登録済みです"}
  validates :url, :presence => {:message => "RSSのURLを入力して下さい。"},
            :length => {:maximum => 255, :message => "255文字以内で入力ください。"}
  module Status
    OPEN = 0
    STOP = 1
  end

  def state_name
    case status
    when Status::OPEN
      "公開中"
    when Status::STOP
      "停止中"
    end
  end
end
