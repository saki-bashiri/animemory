class XmlController < ApplicationController
  def matome
    @summaries = Summary.includes(:episode, :anime).order("created_at DESC").limit(10)

    respond_to do |format|
      response.headers['Content-Type'] = 'application/xml; charset=utf-8'
      format.rss { render :layout => false }
    end
  end
end