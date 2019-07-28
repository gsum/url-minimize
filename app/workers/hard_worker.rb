class HardWorker
  require 'rest-client'
  include Sidekiq::Worker

  def perform(id)
    short_url_object = ShortUrl.find(id)
    website = RestClient.get(short_url_object.original_url)
    if website.present?
      string_website = website.to_s
      title = string_website.match(/<title.*?>(.*)<\/title>/)[1]
      short_url_object.title = title
      short_url_object.save
    end
  end
end
