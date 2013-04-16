class ShortenerRedirectMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)

    if (env["PATH_INFO"] =~ ::Shortener.match_url) && (shortener = ::Shortener::ShortenedUrl.find_by_unique_key($1))
      shortener.track env if ::Shortener.tracking
      [301, {'Location' => shortener.url}, []]
    else
      @app.call(env)
    end

  end
end
