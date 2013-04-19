class Shortener.Views.ShortenedUrlsModel extends Backbone.View

  template: JST['shortener/shortened_urls/model']

  events:
    "click .destroy" : "destroy"

  tagName: 'tr'

  initialize: ->
    @model.on("change reset", @render, this)

  destroy: (e) ->
    @model.destroy()
    @remove()

    false

  render: ->
    @$el.html(@template(model: @model))
    this
