class MymemoryController < ApplicationController

  before_filter :auth
  #verify :xhr, :only => [:favorite, :watch, :episode_watch, :get_memories]
  #verify :method => :post, :only => [:favorite, :watch, :episode_watch, :get_memories]

  def favorite
    @anime = Anime.where(:id => params[:aid].to_i).first
    raise if @anime.blank?

    mymemory = get_mymemory
    mymemory.favorite_flg = params[:favorite].present? && params[:favorite].to_sym == :favorite

    mymemory.save!

    now_fav = mymemory.favorite_flg ? "favorite" : "unfavorite"
    next_fav = !mymemory.favorite_flg ? "favorite" : "unfavorite"
    name = mymemory.favorite_flg ? "" : ""
    render :json => {:next_favorite => next_fav, :class => now_fav, :name => name}.to_json
  end

  def watch
    @anime = Anime.where(:id => params[:aid].to_i).first
    raise if @anime.blank?

    mymemory = get_mymemory
    watch_status_num = params[:watch].present? ? Mymemory.watch_status_num(params[:watch].to_sym) : nil
    mymemory.watch_status = watch_status_num if watch_status_num

    mymemory.save!

    next_watch = mymemory.next_watch_status_sym

    render :json => {:next_watch => next_watch, :class => mymemory.watch_status_to_sym, :name => mymemory.watch_status_name}.to_json
  end

  def episode_watch
    @episode = Episode.where(:id => params[:epid].to_i).first
    raise if @episode.blank?

    memory = EpisodeMemory.get_memory(@user.id, @episode)
    watch_status_num = params[:watch].present? ? EpisodeMemory.watch_status_num(params[:watch].to_sym) : nil
    memory.watch_status = watch_status_num if watch_status_num.present?
    memory.save!
    render :json => {}.to_json
  end

  private

  def get_mymemory
    mymemory = Mymemory.where(:anime_id => @anime.id, :user_id => @user.id).first

    if mymemory.blank?
      mymemory = Mymemory.new
      mymemory.user_id = @user.id
      mymemory.anime_id = @anime.id
    end
    mymemory
  end
end
