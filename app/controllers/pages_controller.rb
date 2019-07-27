class PagesController < ApplicationController
  def index
  end

  def show
    short_url_object = ShortUrl.find_by_base_url(params[:unmatched_route])
    if short_url_object.present?
      redirect_to "http://minecraft.com", status: 301

    end
  end
end
