class CharacterController < ApplicationController
  http_basic_authenticate_with :name => 'shinkawasaki', :pass => 'nakayamadaigo', :only => [:add, :add_conf] if Rails.env == "production"
  def add
    @anime = Anime.includes(:characters).where(["id = ?", params[:anime].to_i]).first
    @vactors = Artist.where("voice_actor_flg = ?", 1).map{|actor| [actor.name, actor.id]}.unshift(["なし", 0])
    raise "指定されたアニメがありません。" if @anime.blank?

  end

  def add_conf
    raise "不正な遷移です" unless request.post?
    @anime = Anime.includes(:characters).where(["id = ?", params[:anime].to_i]).first
    raise if @anime.blank? || params[:character].blank? || params[:character][:name].blank?

      character = params[:character]
      @character = Character.new
      @character.anime_id = @anime.id
      @character.name = character[:name].to_s.gsub(/(\t|\s|　|\r|\n)/,"")
      @character.kana = character[:kana].to_s.gsub(/(\t|\s|　|\r|\n)/,"") if character[:kana].present?
      @character.artist_id = character[:arid].to_i if character[:arid].present?
      @character.description = character[:description].to_s if character[:description].present?
    if params[:conf].present?


    elsif params[:commit].present?
      @character.save!
      redirect_to :action => "add", :anime => @anime.id
    else
      raise "不正な遷移です。"
    end
  end

end
