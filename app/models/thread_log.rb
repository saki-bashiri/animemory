class ThreadLog < ActiveRecord::Base
  belongs_to :board
  has_many :thread_responses

  class << self
    def find_for_update_or_create(subject_hash, board_id)
      dat_cds = subject_hash.keys
      threads = self.all(:conditions => ["dat_cd IN (?)", dat_cds])
      update_threads = []
      threads.each do |thread|
        update_threads << thread if subject_hash[thread.dat_cd].present? && subject_hash[thread.dat_cd][:count] > thread.count
      end

      new_dat_cds = dat_cds - threads.map(&:dat_cd)

      #raise dat_cds.inspect + " aaa " + threads.map(&:dat_cd).inspect + " aaa " + new_dat_cds.inspect
      board = Board.where("id = ?", board_id).first
      new_dat_cds.uniq.each do |dat_cd|
        next if self.where("dat_cd = ?", dat_cd).size > 0
        subject_set = subject_hash[dat_cd]
        new_thread = self.new
        new_thread.dat_cd = dat_cd.to_i
        new_thread.subject = subject_set[:subject]
        new_thread.count = subject_set[:count]
        new_thread.board_id = board.id
        success_flg = new_thread.save rescue false
        update_threads << new_thread if success_flg
      end
      update_threads
    end
  end
end
