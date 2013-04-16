class Shortener::ShortenedClick < ActiveRecord::Base
  belongs_to :shortened_url

  def track env
    binding.pry
  end
end
