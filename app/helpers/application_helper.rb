module ApplicationHelper
  require 'jcode'

  def create_url(url_hash, options = {})
    url = ''
    https_flg     = !!options.delete(:https) && Rails.env == 'production'
    full_path_flg = !!options.delete(:full_path) || https_flg

    if full_path_flg
      url_hash.delete(:only_path)
      domain = ( Rails.env == 'production' ) ? "animemory.jp" : "#{ENV['USER'].gsub(/\_/, "-")}.krewmo.com"
      protocol = https_flg ? "https://" : "http://"
      url << protocol
      url << domain
      url << url_for(url_hash)
      return url
    else
      return url_for(url_hash)
    end
  end

  def anime_image_path(path, options = {})
    path = "/images/no_image.jpg" if path.blank?

    url = ''
    path = "/#{path}" if /^\/.*/ !~ path
    domain = ( Rails.env == "production" ) ? "img.animemory.jp" : "a-img.krewmo.com"
    protocol = options[:https] ? "https://" : "http://"
    url << protocol
    url << domain
    url << path
    url
  end

  def cut_str(str, limit)
    return "" if str.blank?
    count = str.jlength.to_i
    return str if count < limit
    count.times do |i|
      str = str.chop
      break if str.jlength == (limit - 1)
    end

    ret = str + "…"
  end

  def weekdays
    [["日", 0], ["月", 1], ["火", 2], ["水", 3], ["木", 4], ["金", 5], ["土", 6]]
  end

  def animetime(time, option = {})
    month = time.month
    day = time.day
    hour = time.hour
    min = ( time.min < 10 ? "0#{time.min}" : time.min.to_s )
    wday = time.wday
    if time.hour.present? && time.hour.to_i < 5
      hour = time.hour + 24
      month = (time - 1.day).month
      day = (time - 1.day).day
      wday = (time - 1.day).wday
    end
    wdays = ["日", "月", "火", "水", "木", "金", "土"]

    if option[:time]
      ret = "#{hour}:#{min}"
    else
      ret = "#{month}/#{day}(#{wdays[wday]}) #{hour}:#{min}"
    end
    return ret
  end

  def br(text, options={})
    return text if text.nil?
    text = h text if options[:no_h].blank?
    text.gsub(/\r\n|\r|\n/, "<br/>").html_safe
  end

  def birthday(date)
    if date.year == 0
      ret = date.strftime("%m/%d")
    else
      ret = date.strftime("%Y/%m/%d")
    end
    ret.html_safe
  end

  def user_nickname(user)
    if user.blank?
      nickname = "名無しさん"
    else
      nickname = user.nickname
    end
  end

  def anime_with_episode(anime, episode=nil)
    if episode.present?
      "#{anime.title} 第#{episode.episode}話 #{episode.subtitle}"
    else
      "#{anime.title}"
    end
  end

  def mymemory_js_data
    content_tag(:span, "", :id => "mymemory-data",
                "data-watch-url"    => url_for(:controller => :mymemory, :action => :watch),
                "data-favorite-url" => url_for(:controller => :mymemory, :action => :favorite),
                "data-watch-keys"   => Mymemory::WatchStatus::KEYS.map(&:to_s).to_json,
                "data-favorite-keys" => Mymemory::FavoriteStatus::KEYS.map(&:to_s).to_json,
                "data-watch-name"   => Mymemory::WatchStatus::NAME.to_json,
                "data-watch-balloon-name" => Mymemory::WatchStatus::BALLOON_NAME.to_json,
                "data-favorite-name" => Mymemory::FavoriteStatus::NAME.to_json,
                "data-next-watch"   => Mymemory::WatchStatus::NEXT_WATCH_STATUS_SYM.to_json,
                "data-next-favorite" => Mymemory::FavoriteStatus::NEXT_FAVORITE_STATUS_SYM.to_json,
                "data-user-login"    => @user.present?,
                :style => "display:none;")
  end

  def mymemory_button(mymemory, options = {})
    content_tag(:span, favorite_button(mymemory, options) + watch_button(mymemory, options), "data-aid" => mymemory.anime_id, :class => "mymemory")
  end

  def favorite_button(mymemory, options = {:button => {}, :balloon => {}, :nologin => {}})
    # ログインしてる場合、mymemoryは必ず渡す
    if mymemory.blank? || mymemory.user_id.nil?
      nologin_class = ["unfavorite", "mymemo-fv", options[:nologin].delete(:class)].compact.join(" ")
      nologin_options = options[:nologin].merge(:class => nologin_class)
      nologin_button_tag = link_to "", url_for(:controller => :account, :action => :auth_twitter), nologin_options
      favorite_balloon_tag = content_tag(:span, "ログインして視聴管理", options[:balloon] || {})
      return nologin_button_tag + favorite_balloon_tag
    end
    return if options[:button].blank? || options[:balloon].blank?

    currentFavorite = mymemory.favorite_status_to_sym
    button_class = options[:button].delete(:class) || ""
    button_options = options[:button].merge(:class => [button_class, currentFavorite].join(" "), "data-favorite" => currentFavorite, "data-aid" => mymemory.anime_id)

    favorite_button_tag = link_to "", "#", button_options
    favorite_balloon_tag = content_tag(:span, mymemory.next_favorite_status_name, options[:balloon] || {})

    favorite_button_tag + favorite_balloon_tag
  end

  def watch_button(mymemory, options = {:button => {}, :balloon => {}, :nologin => {}})
    # ログインしてる場合、mymemoryは必ず渡す
    if mymemory.blank? || mymemory.user_id.nil?
      nologin_class = ["not_watched", "mymemo-wc", options[:nologin].delete(:class)].compact.join(" ")
      nologin_options = options[:nologin].merge(:class => nologin_class)
      nologin_button_tag = link_to Mymemory::WatchStatus::NAME[:not_watched], url_for(:controller => :account, :action => :auth_twitter), nologin_options
      watch_balloon_tag = content_tag(:span, "ログインして視聴管理", options[:balloon] || {})
      return nologin_button_tag + watch_balloon_tag
    end

    name       = mymemory.watch_status_name
    current_watch = mymemory.watch_status_to_sym
    button_class = options[:button].delete(:class) || ""
    button_options = options[:button].merge("data-watch" => current_watch, "data-aid" => mymemory.anime_id, :class => [button_class, current_watch].join(" ") )

    watch_button_tag = button_tag name, button_options
    watch_balloon_tag = content_tag(:span, mymemory.watch_balloon_name, options[:balloon] || {})

    watch_button_tag + watch_balloon_tag
  end

  def episode_memory_js_data
    content_tag(:span, "", :id => "episode-memory-data", "data-url" => url_for(:controller => :mymemory, :action => :episode_watch),
      "data-watch-keys"   => EpisodeMemory::WatchStatus::KEYS.map(&:to_s).to_json,
      "data-watch-name"   => EpisodeMemory::WatchStatus::NAME.to_json,
      "data-watch-class"  => EpisodeMemory::WatchStatus::TAG_CLASS.to_json,
      "data-watch-balloon" => EpisodeMemory::WatchStatus::BALLOON_NAME.to_json,
      "data-next-watch"   => EpisodeMemory::WatchStatus::NEXT_STATUS_SYM.to_json,
      :style => "display:none;")
  end

  def episode_memory_button(episode_memory, user, episode, options = {})
    if user.blank?
      episode_memory = EpisodeMemory.new(:episode_id => episode.id, :anime_id => episode.anime_id)
      html_options = options.merge("data-watch" => :not_watched, "data-epid" => episode.id, :class => "#{episode_memory.watch_tag_class} #{options[:class]} nologin-episode-watch",
                                   "data-url" => url_for(:controller => :account, :action => :auth_twitter, :epid => episode.id, :epm_watch => episode_memory.next_watch_status_sym))
      balloon_tag = content_tag(:span, "ログインする", :class => "episode-memory-balloon", :style => "display:none;")
      return content_tag(:span, ( button_tag(EpisodeMemory::WatchStatus.status_name(:not_watched), html_options ) + balloon_tag), :class => "episode-memory-box" )
    end

    if episode_memory.blank?
      episode_memory = EpisodeMemory.new(:user_id => user.id, :episode_id => episode.id, :anime_id => episode.anime_id)
    end

    name = episode_memory.watch_status_name
    current_status = episode_memory.watch_status_to_sym
    balloon_name = episode_memory.watch_balloon_name
    html_options = options.merge("data-watch" => current_status, "data-epid" => episode_memory.episode_id, :class => "#{episode_memory.watch_tag_class} #{options[:class]}")

    content_tag(:span, ( button_tag(name, html_options) + content_tag(:span, balloon_name, :class => "episode-memory-balloon", :style => "display:none;") ), :class => "episode-memory-box" )
  end

  def my_channel_button(creator_id, is_registered, options = {})
    switch = is_registered ? "on" : "off"
    ch_button_tag = button_tag("",
                               :class => "my-channel-button", "data-creatorid" => creator_id, "data-switch" => switch)
    balloon_tag = content_tag(:span, "", :style => "display:none;", :class => "my-channel-balloon")

    content_tag(:span, ch_button_tag + balloon_tag, :class => "my-channel-wrap" )
  end

  def wiki(text)
    return "" if text.blank?
    escaped_text = html_escape(text).dup
    wiki_sizing!(escaped_text)
    wiki_coloring!(escaped_text)

    ret = br(escaped_text, :no_h => true).html_safe
  end

  def wiki_sizing!(text)
    text.gsub!(/\[size:(\d+)\s([^\]]+)\]/, '<span class="wiki" data-size="\1">\2</span>')
  end

  def wiki_coloring!(text)
    text.gsub!(/\[color:([^\s]+)\s([^\]]+)\]/, '<span class="wiki" data-color="\1">\2</span>')
  end

  def amazon_advertise_iframe(asin)
    options = {
      "lt1" => "_blank",
      "bc1" => "FFFFFF",
      "IS2" => "1",
      "nou" => "1",
      "bg1" => "FFFFFF",
      "fc1" => "000000",
      "lc1" => "0000FF",
      "t"   => "animemory06-22",
      "o"   => "9",
      "p"   => "8",
      "l"   => "as1",
      "m"   => "amazon",
      "f"   => "ifr",
      "ref" => "tf_til",
      "asins" => h(asin)
    }
    query_strings = []
    options.each{|key, value| query_strings << "#{key}=#{value}"}
    src = "http://rcm-fe.amazon-adsystem.com/e/cm?" + query_strings.join("&")
    %Q|<iframe src="#{src}" style="width:120px;height:240px;" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"></iframe>|.html_safe
  end

  def ago_from_now(datetime)
    now = Time.now
    diff_seconds = now - datetime
    return "#{diff_seconds.to_i}秒前" if diff_seconds < 60
    diff_minutes = diff_seconds / 60
    return "#{diff_minutes.to_i}分前" if diff_minutes < 60
    diff_hours = diff_minutes / 60
    return "#{diff_hours.to_i}時間前" if diff_hours < 24
    diff_days = diff_hours / 24
    return "#{diff_days.to_i}日前"
  end
end
