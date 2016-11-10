class SmartphoneController < ApplicationController
  SUMMARY_SIZE = 10

  def index
    now = Time.zone.now
    @today = now - ( 3600*now.hour + 60*now.min + now.sec ) + 5*3600
    @today -= 1.day if now.hour < 5

    @new_summaries     = Summary.includes(:anime_image).order("created_at DESC").limit(SUMMARY_SIZE)
    @outside_summaries = OutsideSummary.open_outside_summaries.order("posted_at DESC").limit(10)
    @new_animes        = Anime.includes(:anime_image).order("created_at DESC").limit(6)
  end

  def summary_index
    @summary           = Summary.includes(:summary_contents).where("id = ?", params[:sid].to_i).first
    @new_summaries     = Summary.includes(:summary_contents).where("summaries.id <> ?", @summary.id).order("created_at DESC").limit(4)
    @outside_summaries = OutsideSummary.open_outside_summaries.order("posted_at DESC").limit(10)
  end

  def ajax_get_summaries
    # raise unless request.xhr?

    offset = params[:offset].to_i * SUMMARY_SIZE
    summaries = Summary.includes(:anime_image).order("created_at DESC").offset(offset).limit(SUMMARY_SIZE)

    render :partial => "new_summaries", :locals => {:new_summaries => summaries}
  end

  def comment_post
    summary = Summary.where("summaries.id = ?", params[:sid].to_i).first
    raise "NG" if summary.blank? || params[:content].blank?

    max_res_count = SummaryResponse.where("summary_id = ?", summary.id).maximum("res_sort").to_i

    SummaryResponse.create!(:summary_id => summary.id, :res_sort => (max_res_count + 1), :content => params[:content].to_s)

    redirect_to :action => "summary_index", :sid => summary.id, :aid => summary.anime_id
  end
end
