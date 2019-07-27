class Api::V1::UrlsController < ApplicationController
  def top
    top_hits = ShortUrl.limit(100).order(hit_count: :desc)
    render json: top_hits, status: 302
  end

  def url
    short_url_object = ShortUrl.find_by_original_url(params[:url])
    if short_url_object.present?
      render json: short_url_object, status: 302
    else
      short_url_object = ShortUrl.create!(original_url: params[:url])
      render json: short_url_object, status: 201
    end
  end

  def show
    short_url_object = ShortUrl.find_by_base_url(params[:unmatched_route])
    if short_url_object.present?
      response.set_header("Redirecting to","minecraft.com")
      redirect_to "http://minecraft.com", status: 301
    else
      response.set_header("Message", "Shorted url not found")
      render "pages/show", status: 404
    end
  end
end
