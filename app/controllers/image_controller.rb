class ImageController < ApplicationController

  def anime
  end


  def anime_upload
    begin

      raise "画像を指定してください。" if params[:file].blank?

      anime = Anime.where("id = ?", params[:aid].to_i).first

      max_sort = AnimeImage.where("anime_id = ?", anime.id).select("anime_images.sort").map(&:sort).uniq.compact.max.to_i
      image = AnimeImage.new
      image.set_path(params[:file])
      image.anime_id = anime.id
      image.user_id = @user.id
      image.image_type = 1
      image.sort = max_sort + 1

      raise image.error if image.error.present?
      image.save!
      render :json => {:message => "アップロードに成功しました。"}
    rescue
      render :json => {:message => "アップロードに失敗しました。"}, :status => 200
    end
  end

  def anime_delete
    raise "不正な遷移です。" unless request.post? && @user.present?
    raise "不正な遷移です。" unless params[:image].is_a?(Array)

    anime = Anime.where("id = ?", params[:aid].to_i).first
    image_ids = params[:image].map(&:to_i)
    images = AnimeImage.where("status = ?", AnimeImage::OPEN).where("id IN (?)", image_ids).where("anime_id = ?", anime.id).where("user_id = ?", @user.id)

    images.each do |image|
      image.status = AnimeImage::DELETE
      image.save!
    end

    redirect_to :controller => "anime", :action => "image_up", :aid => anime.id
  end
end
