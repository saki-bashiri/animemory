class Tasks::AnimeDataCrawler

  class << self
    def execute
      @logger = ActiveSupport::BufferedLogger.new(File.join(Rails.root, 'log', "anime_data_crawler_#{Time.zone.now.strftime('%Y%m%d')}.log"))
      tids = Anime.where(:finish_flg => false).all.map(&:shoboi_tid).compact.uniq

      tids.each_slice(50) do |sliced_tids|
        @logger.info "#{sliced_tids.join(',')}"
        am = AnimeMigrator.new(sliced_tids)
        am.anime_update!
      end
    end
  end
end