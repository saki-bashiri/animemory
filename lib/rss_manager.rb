class RssManager
  require 'rss'
  attr_reader :each_rss, :errors

  def initialize
    @errors = []
    get_all_rss
  end

  def get_all_rss
    @each_rss = {}

    outside_sites = OutsideSite.where("status = ?", OutsideSite::Status::OPEN).all
    outside_sites.each do |outside_site|
      begin
        uri = URI(outside_site.rss_url)
        http = Net::HTTP.new(uri.host)
        response = http.get(uri.request_uri)
        @each_rss[outside_site.id] = RSS::Parser.parse(response.body, true)
      rescue => ex
        next
      end
    end
  end

  def create_outside_links
    @each_rss.each do |site_id, rss|
      item_hash = {}
      items = rss.items.presence || rss.items
      @errors << "site_id: #{site_id} RSS ERROR" and next if items.blank?
      rss.items.each do |item|
        link = item.link
        posted_at = item.dc_date.presence || item.pubDate
        if link.blank? || item.title.blank? || posted_at.blank?
          @errors << "site_id: #{site_id} RSS ERROR" and next
        end
        item_hash[link] = {
          :url   => link,
          :title => item.title,
          :posted_at => posted_at.to_date,
          :description => item.description
        }
      end
      exist_links = OutsideSummary.where("outside_site_id = ?", site_id).where("url IN (?)", item_hash.values.map{|item| item[:url]}).map(&:url)

      OutsideSummary.transaction do
        item_hash.each do |link, item|
          next if exist_links.include?(link)

          OutsideSummary.create!(
            :site_type       => site_id,
            :outside_site_id => site_id,
            :url             => item[:url],
            :title           => item[:title],
            :posted_at       => item[:posted_at],
            :description     => item[:description]
          )
        end
      end
    end
  end
end
