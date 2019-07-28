class ShortUrlSerializer < ActiveModel::Serializer
  attributes :short_url, :original_url, :hit_count

  def short_url
    "#{ENV["HOST"]}/#{object.base_url}"
  end
end
