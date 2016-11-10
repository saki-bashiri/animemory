class SummaryResponse < ActiveRecord::Base
  attr_accessible :content, :res_sort, :summary_id
  belongs_to :summary

  validates :content, :presence => {:message => "本文を入力して下さい。"},
            :length => {:maximum => 500, :message => "500文字以内で入力ください。"}
end
