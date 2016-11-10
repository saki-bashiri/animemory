class AccountController < ApplicationController

  #
  # ログアウトメソッド
  #
  def logout
    redirect_to :controller => "anime", :action => "index", :protocol => "http://" and return if @user.blank?
    session[:user_id] = nil
    redirect_to :controller => "anime", :action => "index", :protocol => "http://"
  end

  def auth_twitter
    session[:auth_params] = params
    session[:return_to] = request.referer
    redirect_to "/auth/twitter"
  end

  def twitter_callback
    @auth = request.env["omniauth.auth"]
    profile_image_url = @auth["extra"]["raw_info"]["profile_image_url"].to_s.gsub("_normal", "")
    profile_background_image_url = @auth["extra"]["raw_info"]["profile_background_image_url"]
    session[:twitter_token]  = @auth["credentials"]["token"]
    session[:twitter_secret] = @auth["credentials"]["secret"]
    twitter_cd = @auth.extra.access_token.params[:user_id]
    user = User.where(["twitter_cd = ? and status = ?", twitter_cd, User::Status::NORMAL]).readonly(false).first

    url = session[:return_to] || url_for(:controller => :anime, :action => :index)

    # ログイン
    if user.present?
      session[:user_id] = user.id
      user.update_profile_image(profile_image_url, profile_background_image_url)
    # ユーザー登録
    else
      @screen_name = @auth.extra.access_token.params[:screen_name]
      user = User.new
      user.twitter_cd    = twitter_cd.to_i
      user.nickname      = @screen_name.to_s
      user.register_type = User::RegisterType::TWITTER
      user.status        = User::Status::NORMAL
      user.profile_image_url = profile_image_url
      user.profile_background_image_url = profile_background_image_url
      user.save!

      session[:user_id]    = user.id
      url = url_for(:controller => :mypage, :action => :initial_setting)
    end



    #一時措置
    if session[:auth_params].present?
      if session[:auth_params][:epm_watch].present? && session[:auth_params][:epid].present? && ( episode = Episode.where(:id => session[:auth_params][:epid].to_i).first )
        epmemory = EpisodeMemory.where(:user_id => user.id, :episode_id => episode.id).first || EpisodeMemory.new(:user_id => user.id, :episode_id => episode.id, :anime_id => episode.anime_id)
        epmemory.watch_status = EpisodeMemory.watch_status_num(session[:auth_params][:epm_watch].to_s.to_sym)
        epmemory.save!
      end
      session[:auth_params] = nil
    end

    session[:return_to] = nil
    redirect_to url
    return
  end

  def twitter_signout
    session[:twitter_token] = nil
    session[:twitter_secret] = nil
    session[:username] = nil
    redirect_to :controller => "anime", :action => "index"
  end

  def twitter_failure
    redirect_to :controller => "anime", :action => "index"
  end

  def will_quit
    redirect_to :controller => "anime", :action => "index", :protocol => "http://" and return if @user.blank?
  end

  def quitting
    redirect_to :controller => "anime", :action => "index", :protocol => "http://" and return if @user.blank?
  end

  def quit
    raise "不正な遷移です。" unless request.post? && @user.present?

    user = User.where("status = ? AND id = ?", 1, @user.id).readonly(false).first
    raise "退会に失敗しました。サポートにお問い合わせください。" if user.blank?

    user.status = 99
    user.save!

    session[:user_id] = nil
    @user = nil

    render "account/quitted"
  end

  def quitted

  end

private

  def encrypt(mail_address)
    gib = Gibberish.new(Gibberish::KEY)
    enc_mail_address = gib.encrypt(mail_address)
    enc_mail_address
  end

  def decrypt(mail_address)
    gib = Gibberish.new(Gibberish::KEY)
    dec_mail_address = gib.decrypt(mail_address)
    dec_mail_address
  end
end
