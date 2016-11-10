class MyChannelController < ApplicationController
  #verify :xhr, :only => [:favorite, :watch, :episode_watch, :get_memories]
  #verify :method => :post, :only => [:favorite, :watch, :episode_watch, :get_memories]

  def update
    if @user.blank?
      render :json => {:url => url_for(:controller => :account, :action => :auth_twitter)}.to_json
      return
    end

    creator = Creator.where(:id => params[:creatorid].to_i).first

    if creator
      channel = MyChannel.where(:user_id => @user.id, :creator_id => creator.id).first
    end

    if params[:switch] == "on"
      MyChannel.create!(:user_id => @user.id, :creator_id => creator.id) unless channel
    else
      channel.destroy if channel
    end
    render :json => {}.to_json
  end
end
