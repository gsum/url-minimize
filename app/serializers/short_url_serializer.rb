class ShortUrlSerializer < ActiveModel::Serializer
  attributes :short_url, :original_url, :hit_count, :title

  def short_url
    "#{ENV["HOST-URL"]}/#{object.base_url}"
  end
end
