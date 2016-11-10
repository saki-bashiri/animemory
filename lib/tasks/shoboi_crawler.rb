class Tasks::ShoboiCrawler
  class << self
    def execute
      @logger = ActiveSupport::BufferedLogger.new(File.join(Rails.root, 'log', "shoboi_crawler_#{Time.zone.now.strftime('%Y%m%d')}.log"))
      @logger.info "crawl start"
      start_date = Time.zone.now
      days = 10
      manager = ShoboiManager.new(start_date, days)
      manager.reflesh_schedules
      @logger.info "crawl end"
    end
  end
end