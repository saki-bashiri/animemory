class Tasks::ThreadCrawler

  class << self

    def execute
      logger = ActiveSupport::BufferedLogger.new(File.join(Rails.root, 'log', 'batch.log'))

      logger.info("thread crawl start.")
      logger.info("#{Time.zone.now.strftime('%Y-%m-%d %H:%M:%S')}")
      board_ids = Board.select("id").map(&:id)
      board_ids.each do |board_id|
        dat_manager = DatManager.new(board_id)
        subject_hash = dat_manager.get_subjects
        logger.info("thread update start")
        threads = ThreadLog.find_for_update_or_create(subject_hash, dat_manager.board.id)
        logger.info("thread update end")

        logger.info("res update start")
        threads.each_with_index do |thread, index|
          logger.info("#{index} res updated") if index != 0 && index % 100 == 0
          ThreadResponse.refresh!(thread)
        end
      end
      logger.info("res update start")

      logger.info("thread crawl end.")
      logger.flush
    end
  end
end