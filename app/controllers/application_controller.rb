class ApplicationController < ActionController::Base
  include SslRequirement
  before_filter :set_user
  helper_method :signed_in?
  
  def set_user
    if session[:user_id].present?
      @user = User.where("status != ? AND id = ?", User::QUIT,session[:user_id].to_i).first
    end
  end

private
  def redirect_to_https(url_hash)
    if Rails.env == "production"
      url_hash.merge(:protocol => "https://")
    end
    redirect_to url_hash
  end

  def ssl_required?
    return false unless Rails.env.production?
    required = self.class.ssl_required_actions || []
    except  = self.class.ssl_required_except_actions

    unless except
      required.include?(action_name.to_sym)
    else
      !except.include?(action_name.to_sym)
    end
  end

  def local_request?
    false
  end

  def signed_in?
    true if session[:oauth_token]
  end

  def rescue_action_in_public(exception)
    case exception
    when RuntimeError
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 400
    when AnimemoryError
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 400
      return
    else
      super
    end
  end

  def auth
    if @user.blank?
      redirect_to :controller => :account, :action => :auth_twitter
      return false
    end
  end
end
