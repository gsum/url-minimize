class Api::V1::UrlsController < ApplicationController
  def top
    top_hits = ShortUrl.limit(100).order(hit_count: :desc)
    render json: top_hits
  end

  def url
  end

  def show
  end
end
