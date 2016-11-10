class ThreadResponse < ActiveRecord::Base
  belongs_to :thread_log

  class << self
    def refresh!(thread)
      board = thread.board
      res_count = ThreadResponse.where("thread_log_id = ?", thread.id).count
      dat_manager = DatManager.new(board.id)
      results = dat_manager.get_thread(thread.dat_cd)
      index = 0
      update_flg = false
      results.each_slice(100) do |chunked_result|
        ThreadResponse.transaction do
          chunked_result.each do |result|
            index += 1
            next if res_count >= index
            res = self.new
            res.thread_log_id = thread.id
            res.anchor = index
            res.name = result[:name]
            res.posted_at = result[:posted_at]
            res.post_cd = result[:post_cd]
            res.content = result[:content]
            res.save!
            update_flg = true
          end
        end
        sleep(1) if update_flg
      end

      thread.count = results.count
      thread.save!
    end
  end
end
