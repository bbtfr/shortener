window.Shortener =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    Shortener.Collections.ShortenedUrls::url = '/shortened_urls'
    new Shortener.Routers.ShortenedUrls()
    Backbone.history.start()

$(document).ready ->
  Shortener.initialize()
