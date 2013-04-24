class Shortener.Views.ShortenedUrlsIndex extends Backbone.View

  template: JST['shortener/shortened_urls/index']

  className: "container"

  events:
    "submit form": "create"

  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @add, this)

  create: (e) ->
    url = @$("#url").val()
    model = @collection.create url: url

    false

  add: (model) =>
    view = new Shortener.Views.ShortenedUrlsModel({model : model})
    @$("tbody").append(view.render().el)

  render: ->
    @$el.html(@template(collection: @collection))
    @collection.each(@add)
    this
