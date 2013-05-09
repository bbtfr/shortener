class Shortener.Views.ShortenedUrlsShow extends Backbone.View

  template: JST['shortener/shortened_urls/show']

  className: "container"

  events:
    "click .page-header input.h1": "selectAll"

  initialize: ->
    @model.on('reset', @render, this)
    @model.on('change:rqr_url', @updateRqr, this)
    @model.on('change:created_at', @updateCreated, this)
    @updateAll()

  updateAll: ->
    $.getJSON @model.get('details_url'), (data) =>
      @model.set data
      $.getJSON @model.get('clicks_url'), @updateClicks
      $.getJSON @model.get('referrers_url'), @updateReferrers
      $.getJSON @model.get('browsers_url'), @updateBrowsers
      $.getJSON @model.get('countries_url'), @updateCountries
      $.getJSON @model.get('platforms_url'), @updatePlatforms

  updateClicks: (data) =>
    @lineChart("#clicks", data)
    t = 0
    t += v[1] for v in d.data for d in data
    @$("#total_clicks").text(t)

  updateReferrers: (data) =>
    @pieChart("#referrers", data, {series: {pie: {innerRadius: 0.7, radius: 1, label: {show: false}}}})

  updateBrowsers: (data) =>
    @barChart("#browsers", data)

  updateCountries: (data) =>
    @pieChart("#countries", data, {series: {pie: {radius: 500}}})

  updatePlatforms: (data) =>
    @barChart("#platforms", data)

  flotCommonOptions:
    grid: 
      show: true
      aboveData: true
      color: "#3f3f3f"
      labelMargin: 5
      axisMargin: 0
      borderWidth: 0
      borderColor:null
      minBorderMargin: 5
      clickable: true
      hoverable: true
      autoHighlight: true
      mouseActiveRadius: 20
    colors: ["#0088cc", "#ee5f5b", "#fbb450", "#62c462", "#5bc0de", "#444444"]
    tooltip: true, #activate tooltip

  lineChart: (selector, data, options = {}) =>
    defaultOptions =
      series:
        lines:
          show: true
          fill: false
          lineWidth: 4
          steps: false
        points:
          show: true
          radius: 5
          symbol: "circle"
          fill: true
      tooltipOpts: 
        content: "<strong>%x</strong><br>Clicks: <strong>%y</strong>"
        dateFormat: "%b %e, %Y %I:%M%p"
        shifts:
          x: -50
          y: -60
        defaultTheme: false
      xaxis:
        mode: "time"
        timezone: "browser"
      yaxis:
        tickDecimals: 0
    $.plot(@$(selector), data, $.extend(true, options, defaultOptions, @flotCommonOptions))

  barChart: (selector, data, options = {}) =>
    defaultOptions =
      series:
        bars:
          show: true
          horizontal: true
          align: "center"
          barWidth: 0.5
          fill: 1
      tooltipOpts: 
        content: "<strong>%s: %x</strong>"
        shifts:
          x: -30
          y: -40
        defaultTheme: false
      legend:
        show: false
      xaxis:
        tickDecimals: 0
      yaxis:
        mode: "categories"
        tickLength: 0
    console.log data
    $.plot(@$(selector), data, $.extend(true, options, defaultOptions, @flotCommonOptions))

  pieChart: (selector, data, options = {}) =>
    defaultOptions =
      series:
        pie:
          show: true
          highlight: 
            opacity: 0.1
          stroke:
            color: '#fff'
            width: 2
          startAngle: 2
          # label:
          #   show: true
          #   radius: 1
          #   formatter: (label, series) ->
          #       "<div class=\"label label-inverse\">#{label} #{Math.round(series.percent)}%</div>"
      legend:
        show: false
      tooltipOpts:
        content: "<strong>%s: %y</strong>"
        shifts:
          x: -30
          y: -40
        defaultTheme: false
    $.plot(@$(selector), data, $.extend(true, options, defaultOptions, @flotCommonOptions))

  updateRqr: ->
    @$("#rqr").attr(src: @model.get('rqr_url'))

  updateCreated: ->
    @$("#created")
    .attr(title: @model.get('created_at'))
    .timeago()

  selectAll: (e) ->
    $el = $(e.target)
    $el.select()

    false

  render: ->
    @$el.html(@template(model: @model))
    @$(".page-header input.h1").tooltip(trigger: 'focus')
    this


