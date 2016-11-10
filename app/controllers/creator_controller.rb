class CreatorController < ApplicationController

  def index
    crid = params[:crid].to_i
    include_options = [{:staffs => [:staff_anime, :role]}, {:song_artists => {:song => :anime}}, {:characters => :anime}]
    @creator = Creator.includes(include_options).where(:id => crid).first
    raise ActiveRecord::RecordNotFound if @creator.blank? || (!@creator.voice_actor? && !@creator.production?)

    @mychannel_users = User.includes(:my_channels).where("my_channels.creator_id IN (?)", @creator.id).all
    @my_channel = MyChannel.where(:user_id => @user.id, :creator_id => @creator.id).first if @user
  end
end
