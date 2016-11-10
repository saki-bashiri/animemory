class Mymemory < ActiveRecord::Base
  attr_accessible :anime_id, :user_id, :watch_status, :favorite_flg

	belongs_to :anime
  belongs_to :user
  # 件数を反映しておく
  before_save :save_counts
  before_save :update_user_count
  after_save :sometimes_all_calc_update

  module WatchStatus
    NOT_WATCHED = 0
    WATCHING    = 1
    WATCHED     = 2
    KEYS = [:not_watched, :watching, :watched]

    NAME = {:not_watched => "みる！", :watching => "みてる", :watched => "みた"}
    BALLOON_NAME = {:not_watched => "みてる へ登録", :watching => "みた へ登録", :watched => "みた を解除"}
    NEXT_WATCH_STATUS_SYM = {
      :not_watched => :watching,
      :watching    => :watched,
      :watched     => :not_watched
    }
    DEFAULT_BUTTON_NAME = "みる！"
  end

  module FavoriteStatus
    NOT_FAVORITE = 0
    FAVORITE     = 1
    KEYS = [:unfavorite, :favorite]
    NAME = {:unfavorite => "お気に入り解除", :favorite => "お気に入り登録"}
    NEXT_FAVORITE_STATUS_SYM = {
      :unfavorite => :favorite,
      :favorite => :unfavorite
    }
  end

  class << self
    def watch_status_to_sym(num)
      WatchStatus::KEYS[num]
    end

    def watch_status_num(key)
      WatchStatus::KEYS.index(key)
    end

    def where_or_new(user_id, anime_id)
      return nil if user_id.blank?
      mymemory = Mymemory.where(:anime_id => anime_id, :user_id => user_id).first

      if mymemory.blank?
        mymemory = Mymemory.new
        mymemory.user_id = user_id
        mymemory.anime_id = anime_id
      end
      mymemory
    end
  end

  def not_watched?
    self.watch_status_to_sym == :not_watched
  end

  def watch_status_to_sym
    self.class.watch_status_to_sym(self.watch_status)
  end

  def watch_status_name
    WatchStatus::NAME[self.watch_status_to_sym]
  end

  def watch_balloon_name
    WatchStatus::BALLOON_NAME[self.watch_status_to_sym]
  end

  def next_watch_status_sym
    WatchStatus::NEXT_WATCH_STATUS_SYM[watch_status_to_sym]
  end

  def next_watch_status_name
    WatchStatus::NAME[next_watch_status_sym]
  end

  def favorite_status_to_sym
    self.favorite_flg ? :favorite : :unfavorite
  end

  def next_favorite_status_sym
    FavoriteStatus::NEXT_FAVORITE_STATUS_SYM[favorite_status_to_sym]
  end

  def next_favorite_status_name
    FavoriteStatus::NAME[next_favorite_status_sym]
  end

  private

  def save_counts
    anime_score = self.anime.anime_score || AnimeScore.new(:anime_id => self.anime_id)

    if favorite_flg_changed?
      anime_score.favorite_count += favorite_flg ? 1 : (-1)
    end

    if self.watch_status_changed?
      prev_watch_status = self.class.watch_status_to_sym(self.watch_status_was)
      watching_diff, watched_diff = calc_diff
      anime_score.watching_count += watching_diff
      anime_score.watched_count += watched_diff
    end

    anime_score.save! if anime_score.changed?
  end

  def update_user_count
    user_count = UserCount.where(:user_id => self.user_id).first
    return unless user_count

    watching_diff, watched_diff = calc_diff
    user_count.watching_count += watching_diff
    user_count.watched_count += watched_diff
    user_count.favorite_count += ( self.favorite_flg ? 1 : -1 ) if self.favorite_flg_changed?

    user_count.save! if user_count.changed?
  end

  def calc_diff
    watching = 0
    watched = 0

    prev_watch_status = self.class.watch_status_to_sym(self.watch_status_was)
    case prev_watch_status
      when :watching
        watching -= 1
      when :watched
        watched -= 1
    end

    case self.watch_status_to_sym
      when :watching
        watching += 1
      when :watched
        watched +=1
    end
    [watching, watched]
  end

  def sometimes_all_calc_update
    return if rand(10) != 0
    watching_count = self.class.where(:user_id => self.user_id, :watch_status => WatchStatus::WATCHING).count
    watched_count = self.class.where(:user_id => self.user_id, :watch_status => WatchStatus::WATCHED).count
    favorite_count = self.class.where(:user_id => self.user_id, :favorite_flg => true).count
    user_count = UserCount.where(:user_id => self.user_id).first
    user_count.watching_count = watching_count
    user_count.watched_count = watched_count
    user_count.favorite_count = favorite_count
    user_count.save!
  end
end
