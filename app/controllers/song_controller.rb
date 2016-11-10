class SongController < ApplicationController
  def top
    song_id = params[:songid].to_i
    @song = Song.includes(:singer, :composer, :songwriter).where(["id = ? and status = ?", song_id, 1]).first

  end

  def song_register
    raise "アニメが指定されていません" if params[:anime].blank?
    @anime = Anime.includes(:songs).where("id = ?", params[:anime].to_i).first
    @singers = Artist.where("singer_flg = ?", 1)
    @songwriters = Artist.where("songwriter_flg = ?", 1)
    @composers = Artist.where("composer_flg = ?", 1)
  end

  def song_register_conf
    raise "不正な遷移です" unless request.post?
    raise "" if params[:song].blank?
    new_song = params[:song]
    anime_id = params[:anime].to_i

    if params[:conf].present?
      @anime = Anime.find_by_id(anime_id)
      @title = regist_song[:title].to_s
      @singer = Artist.find_by_id(regist_song[:singer_id].to_i) if regist_song[:singer_id].present?
      @composer = Artist.find_by_id(regist_song[:composer_id].to_i) if regist_song[:composer_id].present?
      @songwriter = Artist.find_by_id(regist_song[:songwriter_id].to_i) if regist_song[:songwriter_id].present?
      @song_type = regist_song[:song_type].to_i
      @description = regist_song[:description].to_s
    elsif params[:commit].present?
      @anime = Anime.where("id = ?", anime_id).first
      raise if @anime.blank?

      song = Song.new
      song.anime_id = anime_id
      song.title = new_song[:title].to_s
      if singer = Artist.where("singer_flg = ? and id = ?", 1, new_song[:singer_id].to_i).first
        song.singer_id = singer.id
      end
      if songwriter = Artist.where("songwriter_flg = ? and id = ?", 1, new_song[:songwriter_flg].to_i).first
        song.songwriter_id = songwriter.id
      end
      if conposer = Artist.where("composer_flg = ? and id = ?", 1, new_song[:composer_flg].to_i).first
        song.composer_id = composer.id
      end

      song.song_type = new_song[:song_type].to_i
      song.description = new_song[:description].to_s
      song.save!

      flash[:notice] = "曲情報を編集しました"
      redirect_to :controller => "anime", :action => "dtl", :anime => anime_id
    end

  end

  def song_edit
    raise unless @user.present?
    raise "曲が選択されていません" if params[:song_id].blank?
    song_id = params[:song_id].to_i
    @song = Song.find_by_id(song_id)
    raise "URLが適切でありません" if @song.blank?
    @singers = Singer.all
    @songwriters = Songwriter.all
    @composers = Composer.all
  end

  def song_edit_conf
    raise "不正な遷移です" unless request.post?
    raise "" if params[:song].blank? || params[:song][:id].blank?
    edit_song = params[:song]
    song_id = edit_song[:id].to_i
    @song = Song.find_by_id(song_id)

    if params[:conf].present?
      @anime = Anime.find_by_id(@song.anime_id)
      @title = edit_song[:title].to_s
      @singer = Artist.find_by_id(edit_song[:singer_id].to_i) if edit_song[:singer_id].present?
      @composer = Artist.find_by_id(edit_song[:composer_id].to_i) if edit_song[:composer_id].present?
      @songwriter = Artist.find_by_id(edit_song[:songwriter_id].to_i) if edit_song[:songwriter_id].present?
      @song_type = edit_song[:song_type].to_i
      @description = edit_song[:description].to_s
    elsif params[:commit].present?
      song_history = SongHistory.new
      song_history.song_id = @song.id
      song_history.attributes = @song.attributes
      song_history.editor_id = @user.id
      song_history.save!

      @song.attributes = edit_song
      @song.save!

      redirect_to :controller => "anime", :action => "dtl", :anime => @song.anime_id
    end
  end
end
