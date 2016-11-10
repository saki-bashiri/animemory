class AnimeMigrator

  attr_accessor :range, :shoboi_animes, :debug

  BASE_URL = "http://cal.syoboi.jp/db.php"

  def initialize(range_array)
    @logger = ActiveSupport::BufferedLogger.new(File.join(Rails.root, 'log', "anime_migrator_#{Time.zone.now.strftime('%Y%m%d')}.log"))
    @range = range_array

    get_xml
  end

  def get_xml
    url = "#{BASE_URL}?Command=TitleLookup&TID=#{@range.join(',')}"

    uri = URI(url)
    http = Net::HTTP.new(uri.host)
    response = http.get(uri.request_uri, {})
    xml = response.body
    xml_hash = Hash.from_xml(xml)
    raw_animes = xml_hash["TitleLookupResponse"]["TitleItems"]["TitleItem"]
    @shoboi_animes = []
    raw_animes.each do |raw_anime|
      next unless [1,5,7,10].include?(raw_anime["Cat"].to_i)
      tid = raw_anime["TID"].to_i
      title = raw_anime["Title"]
      other_title = raw_anime["ShortTitle"]
      kana = raw_anime["TitleYomi"]
      finish_flg = raw_anime["Cat"].to_i != 1

      started_on = Date.parse("#{raw_anime["FirstYear"]}-#{raw_anime["FirstMonth"]}-1") rescue nil
      finished_on = Date.parse("#{raw_anime["FirstEndYear"]}-#{raw_anime["FirstEndMonth"]}-1").end_of_month rescue nil

      keywords = raw_anime["Keywords"].to_s.gsub(/wikipedia:(.+)$/, "").split(",") rescue []

      begin
        subtitle_hash = Hash[*raw_anime["SubTitles"].to_s.scan(/\*(\d+)\*(.+)/).map{|array| [array[0].to_i, array[1]] }.flatten]
      rescue
        @logger.info("CAST ERROR tid: #{tid}, title: title")
        subtitle_hash = {}
      end

      begin
        casts = raw_anime["Comment"].match(%r{\*キャスト(\n(.+))+})[0].to_s.gsub(%r{\*キャスト\n}, "").gsub(%r{\*(.+)$}m, "").
          scan(/:(.+):(.+)/).map{|array| {:chara_name => array[0], :cv_names => array[1].to_s.split("、")}}
      rescue
        @logger.info("CAST ERROR tid: #{tid}, title: #{title}")
        casts = []
      end

      staffs, production_names, production_committee = [], [], nil
      begin
        staff_str = raw_anime["Comment"].match(%r!\*スタッフ(\n(.+))+!)[0]
      rescue
        @logger.info("STAFF ERROR tid: #{tid}, title: #{title}")
        staff_str = ""
      end
      raw_staffs = staff_str.to_s.gsub(%r!\*スタッフ\n!, "").gsub(%r!\*(.+)$!m, "").scan(/:(.+):(.+)/)
      raw_staffs.each do |raw_staff|
        role_names = raw_staff[0].to_s.split(/・|&|＆|、|,/).map(&:strip)
        creator_names = raw_staff[1].to_s.gsub(/\((.+)\)/, "").split(/、/).map(&:strip)

        role_names.each do |role_name|
          case role_name
            when "アニメーション制作", "制作", "制作会社"
              production_names += creator_names
            when "製作", "製作委員会"
              production_committee = creator_names.first
            else
              staffs << {:role_name => role_name, :creator_names => creator_names}
          end
        end
      end

      @debug ||= []
      @debug << raw_anime["Comment"]

      song = {}
      data = raw_anime["Comment"].match(%r!(\*オープニングテーマ\d*「[^」]+」(\n([^\*].+))+\n?)+!)[0] rescue ""
      openings = data.scan(%r!(\*オープニングテーマ\d*「([^」]+)」(\n[^\*].*)+\n?)!).compact.map do |a|
        hash = nil
        begin
          creators = a[0].match(%r!\*オープニングテーマ\d*「[^」]+」((\n\:.+\:.+)+)!)[1].strip.split("\n").map do |row|
            result = row.scan(%r!\:(.+)\:(.+)!).flatten
            {:roles => result[0].split("・"), :artists => parse_singer(result[1]) }
          end
          hash =  {:title => a[1], :creators => creators}
        rescue
        end
        hash
      end

      data = raw_anime["Comment"].match(%r!(\*エンディングテーマ\d*「[^」]+」(\n([^\*].+))+\n?)+!)[0] rescue ""
      endings = data.scan(%r!(\*エンディングテーマ\d*「([^」]+)」(\n[^\*].*)+\n?)!).map do |a|
        hash = nil
        begin
          creators = a[0].match(%r!\*エンディングテーマ\d*「[^」]+」((\n\:.+\:.+)+)!)[1].strip.split("\n").map do |row|
            result = row.scan(%r!\:(.+)\:(.+)!).flatten
            {:roles => result[0].split("・"), :artists => parse_singer(result[1]) }
          end
          hash = {:title => a[1], :creators => creators}
        rescue
        end
        hash
      end

      data = raw_anime["Comment"].match(%r!(\*挿入歌「[^」]+」(\n([^\*].+))+\n?)+!)[0] rescue ""
      featureds = data.scan(%r!(\*挿入歌「([^」]+)」(\n[^\*].*)+\n?)!).map do |a|
        hash = nil
        begin
          creators = a[0].match(%r!\*挿入歌「[^」]+」((\n\:.+\:.+)+)!)[1].strip.split("\n").map do |row|
            result = row.scan(%r!\:(.+)\:(.+)!).flatten
            {:roles => result[0].split("・"), :artists => parse_singer(result[1]) }
          end
          hash = {:title => a[1], :creators => creators}
        rescue
        end
        hash
      end
      song = {:op => openings.compact, :ed => endings.compact, :featured => featureds.compact}

      @shoboi_animes << {:tid => tid,
                         :title => title,
                         :other_title => other_title,
                         :kana => kana,
                         :finish_flg => finish_flg,
                         :started_on => started_on,
                         :finished_on => finished_on,
                         :casts => casts,
                         :staffs => staffs,
                         :song => song,
                         :production_names => production_names,
                         :production_committee => production_committee,
                         :subtitle_hash => subtitle_hash,
                         :keywords => keywords
      }
    end
  end

  def parse_singer(data)
    names = data.scan(%r![^(\(|\)|、)]+!)
    results = []
    level = 0
    names.each do |name|
      hash = {:name => name, :members => []}
      case level
        when 0
          results << hash
        when 1
          results.last[:members] << hash
        when 2
          results.last[:members].last[:members] << hash
      end

      match = data.match(%r!\A#{name}([\(\)、]+)!)
      next if match.blank?
      sep = match[1]
      case sep
        when "("
          level += 1
        when ")", ")、"
          level -= 1
      end

      data = data.gsub(%r!\A(#{name}[\(\)、]+)!, "")
    end
    results
  end

  def anime_update!
    @shoboi_animes.each do |shoboi_anime|
      Anime.transaction do
        tid = shoboi_anime[:tid]
        anime = Anime.where(:shoboi_tid => tid).first.presence || Anime.new(:shoboi_tid => tid)

        anime.title = shoboi_anime[:title]
        anime.other_title = shoboi_anime[:other_title]
        anime.kana = shoboi_anime[:kana]
        anime.finish_flg = shoboi_anime[:finish_flg]
        anime.started_on = shoboi_anime[:started_on]
        anime.finished_on = shoboi_anime[:finished_on].try(:end_of_month)
        anime.admin_operation = true

        if shoboi_anime[:production_committee].present?
          anime.production_committee = shoboi_anime[:production_committee]
        end

        begin
          anime.save!
        rescue
          @logger.info("ANIME ERROR tid: #{tid}m title: #{anime.title}")
          next
        end

        character_hash = Character.where(:anime_id => anime.id).all.index_by(&:name)
        shoboi_anime[:casts].each_with_index do |chara_cv, index|
          chara_name = chara_cv[:chara_name]
          cv_names = chara_cv[:cv_names]
          cv_names.each do |raw_cv_name|
            addition = raw_cv_name.match(%r!^[^\(]+(\([^\)]+\))$!)[1] rescue ""
            cv_name = raw_cv_name.gsub(%r!\([^\)]+\)!, "")
            add_chara_name = chara_name.to_s + addition.to_s
            artist = Creator.where(:name => cv_name).first
            if artist.blank?
              begin
                artist = Creator.create!(:name => cv_name, :voice_actor_flg => true)
              rescue
                @logger.info("ARTIST ERROR name: #{cv_name}")
                next
              end
            else
              artist.voice_actor_flg = true
              artist.save! if artist.changed?
            end

            character = character_hash[add_chara_name]
            if character.blank?
              begin
                Character.create!(:anime_id => anime.id, :name => add_chara_name, :creator_id => artist.id, :chara_sort => (index + 1) )
              rescue
                @logger.info("CHARACTER ERROR name: #{add_chara_name}, anime_id: #{anime.id} ")
              end
            end
          end
        end

        role_hash = {}
        Staff.includes(:creator, :role).where(:anime_id => anime.id).all.each do |staff|
          role_hash[staff.role.name] ||= []
          role_hash[staff.role.name] << staff.creator.name
        end
        staff_size = role_hash.values.flatten.size

        shoboi_anime[:staffs].each_with_index do |staff, index|
          role_name = staff[:role_name]
          creator_names = staff[:creator_names]
          creator_names.each do |creator_name|
            next if role_hash[role_name].present? && role_hash[role_name].include?(creator_name)

            role = Role.where(:name => role_name).first.presence || Role.create!(:name => role_name)
            creator = Creator.where(:name => creator_name).first
            if creator
              creator.staff_flg = true
              creator.save!
            else
              creator = Creator.create!(:name => creator_name, :staff_flg => true)
            end
            staff_size += 1
            if Staff.where(:anime_id => anime.id, :role_id => role.id, :creator_id => creator.id).first.blank?
              Staff.create!(:anime_id => anime.id, :role_id => role.id, :creator_id => creator.id, :creator_sort => staff_size )
            end
          end
        end

        production_names = []
        ["アニメーション制作", "制作会社", "制作"].each do |key|
          production_names += ( role_hash[key] || [] )
        end
        if shoboi_anime[:production_names].present?
          production_role = Role.where(:name => "アニメーション制作").first.presence || Role.create!(:name => "アニメーション制作")
          shoboi_anime[:production_names].each do |production_name|
            next if production_names.include?(production_name)

            production = Creator.where(:name => production_name).first
            if production
              production.production_flg = true
              production.save! if production.changed?
            else
              production = Creator.create!(:name => production_name, :production_flg => true)
            end
            staff_size += 1
            staff = Staff.where(:anime_id => anime.id, :role_id => production_role.id, :creator_id => production.id).first
            if staff.blank?
              Staff.create!(:anime_id => anime.id, :role_id => production_role.id, :creator_id => production.id, :creator_sort => staff_size )
            end
          end
        end

        shoboi_anime[:song].each do |song_type, songs|
          songs.each do |song|
            song_artist_hash = {:singer => [], :composer => [], :songwriter => [], :arranger => []}
            title = song[:title]
            song[:creators].each do |creator| # 歌手、作詞者ごとのイテレータ
              roles = creator[:roles]
              artists = creator[:artists]
              artists.each do |artist_data| # 曲一つにつき、歌手が数人の場合のイテレータ
                artist = song_artist_update(artist_data, roles)
                if roles.include?("歌")
                  song_artist_hash[:singer] << artist
                end
                if roles.include?("作詞")
                  song_artist_hash[:songwriter] << artist
                end
                if roles.include?("作曲")
                  song_artist_hash[:composer] << artist
                end
                if roles.include?("編曲")
                  song_artist_hash[:arranger] << artist
                end

                unit_artists = []
                # 代表歌手のユニットメンバー
                artist_data[:members].each do |member_data|
                  second_artist = song_artist_update(member_data, roles)
                  unit_artists << second_artist
                  second_unit_artists = []
                  # 1段目のユニットメンバーが持つユニットメンバー
                  member_data[:members].each do |second_member_data|
                    second_unit_artists << song_artist_update(second_member_data, roles)
                  end
                  second_unit_max_count = Unit.where(:unit_id => second_artist.id).maximum("unit_sort").to_i
                  second_unit_artists.each do |second_unit_artist|
                    next if Unit.where(:unit_id => second_artist.id, :creator_id => second_unit_artist.id).first
                    Unit.create!(:creator_id => second_unit_artist.id, :unit_id => second_artist.id, :unit_sort => (second_unit_max_count + 1) )
                    second_unit_max_count += 1
                  end
                end
                unit_max_count = Unit.where(:unit_id => artist.id).maximum("unit_sort").to_i
                unit_artists.each do |unit_artist|
                  next if Unit.where(:unit_id => artist.id, :creator_id => unit_artist.id).first
                  Unit.create!(:creator_id => unit_artist.id, :unit_id => artist.id, :unit_sort => (unit_max_count + 1) )
                  unit_max_count += 1
                end
              end
            end
            song = Song.where(:anime_id => anime.id, :title => title).first.presence || Song.create!(:anime_id => anime.id, :title => title, :song_type => Song::SongType.type_num(song_type))

            song_artist_hash.each do |song_artist_type, song_artists|
              song_artist_type_num = SongArtist::SongArtistType.type_num(song_artist_type)
              song_artist_max_count = SongArtist.where(:song_id => song.id, :song_artist_type => song_artist_type_num).maximum("artist_sort").to_i
              song_artists.compact.each do |song_artist|
                sa = SongArtist.where(:song_id => song.id, :song_artist_type => song_artist_type_num, :creator_id => song_artist.id).first
                next if sa
                SongArtist.create!(:song_id => song.id, :song_artist_type => song_artist_type_num, :creator_id => song_artist.id, :artist_sort => (song_artist_max_count + 1))
                song_artist_max_count += 1
              end
            end
          end
        end

        episode_hash = Episode.where(:anime_id => anime.id).all.index_by(&:episode)
        shoboi_anime[:subtitle_hash].each do |count, subtitle|
          episode = episode_hash[count]
          if episode.blank?
            episode = Episode.new(:anime_id => anime.id, :episode => count)
          end
          episode.subtitle = subtitle
          episode.save!
        end

        shoboi_anime[:keywords].each do |keyword|
          next if keyword.blank?
          tag = Tag.where(:name => keyword).first.presence || Tag.create!(:name => keyword)
          TagGroup.create!(:anime_id => anime.id, :tag_id => tag.id) rescue nil
        end
      end
    end
  end

  def song_artist_update(artist_data, roles)
    artist_name = artist_data[:name]
    unit_members = artist_data[:members]
    artist = Creator.where(:name => artist_name).first || Creator.new(:name => artist_name, :unit_flg => unit_members.present?)
    artist.singer_flg = roles.include?("歌") unless artist.singer_flg
    artist.composer_flg = ( roles.include?("作曲") || roles.include?("編曲") ) unless artist.composer_flg
    artist.songwriter_flg = roles.include?("作詞") unless artist.songwriter_flg
    artist.save! if artist.changed? || artist.new_record?
    artist
  end
end