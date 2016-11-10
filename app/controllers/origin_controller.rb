class OriginController < ApplicationController
  http_basic_authenticate_with :name => 'shinkawasaki', :pass => 'nakayamadaigo', :except => [:top] if Rails.env == "production"
  def top
    raise "ページエラーです。" if params[:orgid].blank?
    @origin = Origin.includes(:animes).find_by_id(params[:orgid].to_i)
    raise "指定の原作が見つかりません。" if @origin.blank?
    @animes = @origin.animes
  end

  def revision

  end

  def edit
    @origin = Origin.includes(:animes).where("id = ?", params[:orgid].to_i).first
    raise if @origin.blank?
    @origin_animes = @origin.animes
    @animes = Anime.all
  end

  def edit_conf
  end

  def regist
    #redirect_to :controller => "account", :action => "login" if @user.blank?
    @animes = Anime.all
  end

  def regist_conf
    raise "不正な遷移です。" unless request.post? #&& @user.present?
    raise if params[:origin].blank?
    origin = params[:origin]



    if params[:conf].present?
      if origin[:id].to_i > 0
        @origin = Origin.where("id = ?", origin[:id].to_i).first
        raise if @origin.blank?
      else
        @origin = Origin.new
      end

      @origin.title = origin[:title].to_s.gsub(/(\r|\n|\t)/, "").strip
      @origin.description = origin[:description].to_s
      @origin.original_type = origin[:original_type].to_i

      @animes = @origin.animes

      origin[:anime_ids] = @origin.animes.map(&:to_i) if origin[:anime_ids].present? && !origin[:anime_ids].is_a?(Array)
      @animes = Anime.where("id IN (?)", origin[:anime_ids].map(&:to_i)).uniq.compact

    elsif params[:commit].present?
      Origin.transaction do
        if origin[:id].to_i > 0
          @origin = Origin.where("id = ?", origin[:id].to_i).first
        else
          @origin = Origin.new
        end

        @origin.title = origin[:title].to_s.gsub(/(\r|\n|\t)/, "").strip
        @origin.description = origin[:description].to_s
        @origin.original_type = origin[:original_type].to_i
        @origin.status = 1
        @origin.save!


        origin[:anime_ids] = @origin.animes.map(&:to_i) if origin[:anime_ids].present? && !origin[:anime_ids].is_a?(Array)
        animes = Anime.where("id IN (?)", origin[:anime_ids].map(&:to_i))

        delete_anime_ids = @origin.animes.map(&:id) - animes.map(&:id)
        delete_anime_ids.each do |anime_id|
          bind = WithOriginAnime.where("anime_id = ?", anime_id).first
          next if bind.blank?
          bind.destroy
        end

        animes.each do |anime|
          next if WithOriginAnime.where("anime_id = ?", anime.id).first.present?
          origin_anime = WithOriginAnime.new
          origin_anime.origin_id = @origin.id
          origin_anime.anime_id = anime.id
          origin_anime.save!
        end

      end
      redirect_to :controller => "origin", :action => "top", :orgid => @origin.id
    end

  end

end
