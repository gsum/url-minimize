class ShortUrl < ApplicationRecord
  before_create :set_base_url

  private

  def set_base_url
    self.base_url = generate_base_url
  end

  def generate_base_url
    loop do
     token = SecureRandom.urlsafe_base64(5)
     break token unless ShortUrl.where(base_url: token).exists?
   end
  end
end
