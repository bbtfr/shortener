class Shortener.Routers.ShortenedUrls extends Backbone.Router
  routes:
    'shortened_urls': 'index'
    'shortened_urls/:id': 'show'
    '.*': 'index'

  initialize: (options) ->
    @collection = new Shortener.Collections.ShortenedUrls()
    @collection.fetch(reset: true)

  display: (callback) ->
    if @collection.length == 0
      @collection.once 'reset', callback
    else
      callback()

  index: ->
    view = new Shortener.Views.ShortenedUrlsIndex(collection: @collection)
    $('#container').html(view.render().el)

  show: (id) ->
    @display =>
      model = @collection.get(id)
      view = new Shortener.Views.ShortenedUrlsShow(model: model)
      $('#container').html(view.render().el)