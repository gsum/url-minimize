class Api::V1::UrlsController < ApplicationController
  def top
    top_hits = ShortUrl.limit(100).order(hit_count: :desc)
    render json: top_hits, status: 302
  end

  def url
    if sanitize_url(params[:url]).present?
      short_url_object = ShortUrl.find_by_original_url(sanitize_url(params[:url]))
      if short_url_object.present?
        render json: short_url_object, status: 302
      else
        short_url_object = ShortUrl.create!(original_url: sanitize_url(params[:url]))
        render json: short_url_object, status: 201
      end
    else
      render json: { "Response": "Bad Request" }, status: 400
    end
  end

  def show
    short_url_object = ShortUrl.find_by_base_url(params[:unmatched_route])
    if short_url_object.present?
      short_url_object.increment!(:hit_count)
      response.set_header("Redirecting to","minecraft.com")
      redirect_to short_url_object.original_url, status: 301
    else
      response.set_header("Message", "Shorted url not found")
      render "pages/show", status: 404
    end
  end

  private

  def sanitize_url(url)
    url = URI.parse(url)
    if url.scheme.nil?
      url = URI.parse("http://#{url}")
      validate_url(url)
    else
      validate_url(url)
    end
  end

  def validate_url(url)
    if url.scheme.present? && url.host.present? && url.host.include?(".")
      url.to_s
    else
      ""
    end
  end
end
