class Dummy.Routers.ShortenedUrls extends Backbone.Router
  routes:
    'shortened_urls': 'index'
    'shortened_urls/:id': 'show'
    '.*': 'index'

  initialize: (options) ->
    @collection = new Dummy.Collections.ShortenedUrls()
    @collection.fetch(reset: true)

  display: (callback) ->
    if @collection.length == 0
      @collection.once 'reset', callback
    else
      callback()

  index: ->
    view = new Dummy.Views.ShortenedUrlsIndex(collection: @collection)
    $('#container').html(view.render().el)

  show: (id) ->
    @display =>
      model = @collection.get(id)
      view = new Dummy.Views.ShortenedUrlsShow(model: model)
      $('#container').html(view.render().el)