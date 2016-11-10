class AnimeImage < ActiveRecord::Base
  belongs_to :anime
  belongs_to :user
  has_many :summary_images

  attr_accessor :error
  after_save :process

  OPEN = 1
  DELETE = 99

  # moduleに移行していく
  module Status
    OPEN = 1
    DELETE = 99
  end

  def image_path(image_type)
    create_url_path(image_type)
  end

  def set_path(image)
    if image.is_a?(ActionDispatch::Http::UploadedFile)
      content_type = image.content_type
      extension = File.extname(image.original_filename)
      @error = "拡張子はJPG形式でお願いします。" unless [".jpg", ".jpeg"].include?(extension)

      @image_path = image
    else
      @error = "システムエラーです。"
    end
  end



  IMAGE_ROOT = ( Rails.env == "development" ) ? "/home/a_img/public/" : "/home/animemory_img/public/" # ホームディレクトリ
  ANIME_IMAGE_WEB_ROOT = "anime/images/" # anime_images用の保存ディレクトリ相対パス
  ANIME_IMAGE_DIRECTORY = File.join(IMAGE_ROOT, ANIME_IMAGE_WEB_ROOT) # anime_images用保存ディレクトリ絶対パス
  PREFIX = {:path => "" ,
            :path_640x640 => "640x640_",
            :path_200x200 => "200x200_",
            :path_100x100 => "100x100_",
            :path_150x150 => "150x150_",
            :path_256x144 => "256x144_",
            :path_512x288 => "512x288_"}
  IMAGE_EXTENSION = ".jpg"

  private

  def process
    if @image_path
      create_path
      save_images
      @image_path=nil
    end
  end

  def create_url_path(image_type)
    File.join(ANIME_IMAGE_WEB_ROOT, sub_dir, file_name(image_type))
  end

  def create_path
    FileUtils.mkdir_p(File.join(ANIME_IMAGE_DIRECTORY, sub_dir))
  end

  def save_images
    File.open(save_image_path(:path), "w+b") do |file|
      file.puts @image_path.read
    end
    img = Magick::Image.read(save_image_path(:path)).first

    @error = "不正な画像形式です" unless img

    create_thumbnails(img)
    img = nil
  end

  def save_image_path(pref)
    File.join(ANIME_IMAGE_DIRECTORY, sub_dir, file_name(pref))
  end

  def sub_dir
    ( self.id.to_i / 1000 ).to_s
  end

  def file_name(image_type)
    PREFIX[image_type] + self.id.to_s + IMAGE_EXTENSION
  end

  def allow_exts
    [".jpg", ".jpeg"]
  end

  def create_thumbnails(img)
    thumb_image_200x200sq = img.resize_to_fill(200, 200)
    thumb_image_200x200sq.write(save_image_path(:path_200x200))

    thumb_image_100x100sq = img.resize_to_fill(100, 100)
    thumb_image_100x100sq.write(save_image_path(:path_100x100))

    thumb_image_150x150sq = img.resize_to_fill(150, 150)
    thumb_image_150x150sq.write(save_image_path(:path_150x150))

    thumb_image_256x144 = img.resize_to_fill(256, 144)
    thumb_image_256x144.write(save_image_path(:path_256x144))

    thumb_image_512x288 = img.resize_to_fill(512, 288)
    thumb_image_512x288.write(save_image_path(:path_512x288))
  end

end
