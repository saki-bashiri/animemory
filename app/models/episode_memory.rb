class EpisodeMemory < ActiveRecord::Base
  attr_accessible :anime_id, :episode_id, :user_id, :watch_status

  belongs_to :episode
  before_save :save_watched_count

  module WatchStatus
    NOT_WATCHED = 0
    WATCHED     = 1
    WILL_WATCH  = 2

    KEYS = [:not_watched, :watched]
    NAME = {:not_watched => "みた！", :watched => "みた"}
    NEXT_STATUS_SYM = {:not_watched => :watched, :watched => :not_watched}
    TAG_CLASS = {:not_watched => "not-watched", :watched => "watched"}
    BALLOON_NAME = {:not_watched => "みた へ登録する", :watched => "みた を解除"}

    class << self
      def status_name(sym)
        NAME[sym] || NAME[:not_watched]
      end
    end
  end

  class << self
    def get_memory(user_id, episode)
      memory = self.where(:user_id => user_id, :episode_id => episode.id).first
      if memory.blank?
        memory = self.new(:user_id => user_id, :episode_id => episode.id, :anime_id => episode.anime_id)
      end

      memory
    end

    def watch_status_to_sym(num)
      WatchStatus::KEYS[num]
    end

    def watch_status_num(key)
      WatchStatus::KEYS.index(key)
    end
  end

  def watch_balloon_name
    WatchStatus::BALLOON_NAME[self.watch_status_to_sym]
  end

  def watch_tag_class
    WatchStatus::TAG_CLASS[self.watch_status_to_sym]
  end

  def watch_status_to_sym
    self.class.watch_status_to_sym(self.watch_status)
  end

  def watch_status_name
    WatchStatus::NAME[self.watch_status_to_sym]
  end

  def next_watch_status_sym
    WatchStatus::NEXT_STATUS_SYM[watch_status_to_sym]
  end

  def next_watch_status_name
    WatchStatus::NAME[next_watch_status_sym]
  end

  def save_watched_count
    return unless watch_status_changed?

    if self.watch_status_to_sym == :watched
      episode = self.episode
      episode.watched_count += 1
      episode.save!
    end

    if self.class.watch_status_to_sym( watch_status_was ) == :watched
      episode = self.episode
      episode.watched_count -= 1
      episode.save!
    end
  end
end
