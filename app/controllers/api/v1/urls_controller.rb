class Api::V1::UrlsController < ApplicationController
  def top
    top_hits = ShortUrl.limit(100).order(hit_count: :desc)
    render json: top_hits
  end

  def url
    short_url_object = ShortUrl.where(original_url: params[:url])
    if short_url_object.present?
      render json: short_url_object
    else
      short_url_object = ShortUrl.create!(original_url: params[:url])
      render json: short_url_object
    end
  end

  def show
  end
end
