class Tasks::RssCrawler
  class << self
    def execute
      set_logger
      info "crawl start"

      rss_manager = RssManager.new
      rss_manager.create_outside_links

      if rss_manager.errors.present?
        rss_manager.errors.each do |error|
          info "ERROR #{error}"
        end
      end

      info " crawl end"
    end

    def set_logger
      @logger = ActiveSupport::BufferedLogger.new(File.join(Rails.root, 'log', "rss_crawler_#{Time.zone.now.strftime('%Y%m%d')}.log"))
    end

    def info(str)
      @logger.info "#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")} #{str.to_s}"
    end
  end
end