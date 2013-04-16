class Dummy.Views.ShortenedUrlsIndex extends Backbone.View

  template: JST['shortened_urls/index']

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
    view = new Dummy.Views.ShortenedUrlsModel({model : model})
    @$("tbody").append(view.render().el)

  render: ->
    @$el.html(@template(collection: @collection))
    @collection.each(@add)
    this
