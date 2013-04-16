window.Dummy =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    Dummy.Collections.ShortenedUrls::url = '/shortened_urls'
    new Dummy.Routers.ShortenedUrls()
    Backbone.history.start()

$(document).ready ->
  Dummy.initialize()
