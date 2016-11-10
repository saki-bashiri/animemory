class OutsideSummary < ActiveRecord::Base
  attr_accessible :description, :posted_at, :site_name, :site_type, :title, :url, :outside_site_id
  belongs_to :outside_site

  class << self
    def open_outside_summaries(options = {})
      finds = self.includes(:outside_site).where("outside_sites.status = ?", OutsideSite::Status::OPEN)
      finds.includes(options[:includes]) if options[:includes]
      finds.order(options[:order]) if options[:order]
      finds.limit(options[:limit]) if options[:limit]
      finds
    end
  end

  def site_name
    self.outside_site.try(:site_name)
  end
end
