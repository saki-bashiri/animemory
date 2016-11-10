class ArtistController < ApplicationController
  http_basic_authenticate_with :name => 'shinkawasaki', :pass => 'nakayamadaigo', :only => [:regist, :regist_conf, :revision, :edit, :edit_conf] if Rails.env == "production"

  def top
    raise "ページエラーです。" if params[:artid].blank?
    @artist = Artist.includes(:sing_songs, :compose_songs, :write_songs).find_by_id(params[:artid].to_i)
    raise "指定の歌手、作詞作曲者が見つかりません。" if @artist.blank?
    @sings = @artist.sing_songs
    @composes = @artist.compose_songs
    @writes = @artist.write_songs
  end

  def regist
    # redirect_to :controller => "account", :action => "login" if @user.blank?
    @artist = Artist.find_by_id(params[:artid].to_i) if params[:artid].to_i > 0
    if @artist.present?
      @unit_flg = @artist.unit_flg > 0 ? true : nil
      @vactor_flg = @artist.voice_actor_flg > 0 ? true : nil
      @singer_flg = @artist.singer_flg > 0 ? true : nil
      @composer_flg = @artist.composer_flg > 0 ? true : nil
      @writer_flg = @artist.songwriter_flg > 0 ? true : nil
    end
  end

  def regist_conf
    raise "不正な遷移です。" unless request.post? #&& @user.present?
    raise if params[:artist].blank?
    artist = params[:artist]
    @artist = Artist.new
    if params[:artid].to_i > 0
      @artist = Artist.find_by_id(params[:artid].to_i)
    end

    if params[:conf].present?
      @artist.name = artist[:name]
      @artist.kana = artist[:kana]
      @artist.nickname = artist[:nickname]
      @artist.birthday = Date.parse(artist[:birthday]) if artist[:birthday] =~ /\d+\/\d+\/\d+/
      @artist.description = artist[:description]
      @artist.unit_flg = 1 if artist[:unit_flg].to_i == 1
      @unit_members = Artist.where("id in (?)", artist[:unit_ids].to_s.split(",").map(&:to_i)) if artist[:unit_ids].present?
      @artist.unit_ids = @artist[:unit].map(&:id).join(",") if @artist[:unit].present?
      @artist.voice_actor_flg = 1 if artist[:voice_actor_flg].to_i == 1
      @artist.singer_flg = 1 if artist[:singer_flg].to_i == 1
      @artist.composer_flg = 1 if artist[:composer_flg].to_i == 1
      @artist.songwriter_flg = 1 if artist[:songwriter_flg].to_i == 1
    elsif params[:commit].present?
      Artist.transaction do
        @artist.name = artist[:name].to_s
        @artist.kana = artist[:kana].to_s
        @artist.nickname = artist[:nickname].to_s
        @artist.description = artist[:description]
        @artist.birthday = Date.parse(artist[:birthday]) if artist[:birthday] =~ /\d+-\d+-\d+/
        @artist.unit_flg = 1 if artist[:unit_ids].present?
        @artist.voice_actor_flg = 1 if artist[:voice_actor_flg].to_i == 1
        @artist.singer_flg = 1 if artist[:singer_flg].to_i == 1
        @artist.composer_flg = 1 if artist[:composer_flg].to_i == 1
        @artist.songwriter_flg = 1 if artist[:songwriter_flg].to_i == 1
        @artist.save!


        #@artist_revision = ArtistRevision.new
        #@artist_revision.attributes = @artist.attributes
        #@artist_revision.artist_id = @artist.id
        #@artist_revision.user_id = @user.id
        #@artist_revision.created_at = Time.zone.now
        #@artist_revision.updated_at = Time.zone.now

        if artist[:unit_ids].present?
          unit_ids = artist[:unit_ids].to_s.split(",").map(&:to_i)
          unit_ids.each do |uartist_id|
            unit = Unit.new
            unit.unit_id = @artist.id
            unit.artist_id = uartist_id
            unit.save!
          end
         # @artist_revision.unit_ids = unit_ids.join(",")
        end

        #@artist_revision.save!
      end
      redirect_to :controller => "artist", :action => "top", :artid => @artist.id
    end
  end

  def revision

  end

  def edit
    raise "ページエラーです。" if params[:artid].blank?
    @artist = Artist.includes(:sing_songs, :compose_songs, :write_songs).find_by_id(params[:artid].to_i)
  end

  def edit_conf
    raise unless request.post?

    @artist = Artist.find_by_id(params[:artid].to_i, :readonly => false)

    if params[:conf].present?
    elsif params[:commit].present?

    end
  end

end
