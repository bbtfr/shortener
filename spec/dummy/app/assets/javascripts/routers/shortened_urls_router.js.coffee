class Dummy.Routers.ShortenedUrls extends Backbone.Router
  routes:
    'shortened_urls': 'index'
    '.*': 'index'

  initialize: (options) ->
    @collection = new Dummy.Collections.ShortenedUrls()
    @collection.fetch(reset: true)
    
  index: ->
    view = new Dummy.Views.ShortenedUrlsIndex(collection: @collection)
    $('#container').html(view.render().el)