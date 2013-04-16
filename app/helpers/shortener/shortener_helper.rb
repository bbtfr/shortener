module Shortener::ShortenerHelper

  # generate a url from a url string
  def short_url(url, args = {})
    shortener = Shortener::ShortenedUrl.generate!(url, args)
    shortener ? URI.join(root_url, Shortener.clean_url_prefix, shortener.unique_key).to_s : url
  end

end
