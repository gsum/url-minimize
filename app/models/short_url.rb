class ShortUrl < ApplicationRecord
  before_create :set_base_url, :set_default_hit_count
  after_create :update_title

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

  def set_default_hit_count
    self.hit_count = 0
  end

  def update_title
    HardWorker.perform_async(self.id)
  end
end
