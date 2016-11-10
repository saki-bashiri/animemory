class SummaryComment < ActiveRecord::Base
  attr_accessible :summary_idm, :comment_number, :content, :summary_content_id, :comment_res_number, :created_at, :updated_at
  belongs_to :summary
  belongs_to :summary_content
end
