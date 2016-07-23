@AL.module "HeaderApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    showHeader: ->
      # console.log 'config stuff', Rails.config.x.locale_name, Rails.config.x.locale_latlng
      headerView = @getHeaderView()
      App.headerRegion.show headerView

    getHeaderView: ->
      new Show.Header

    loadAbout: (e)->
      # e.preventDefault()
      @wHeight = Math.max(document.documentElement.clientHeight, window.innerHeight || 0)
      # console.log 'resize to '+@wHeight*0.85
      if $("#about").is(':visible')
          $("#about").fadeOut()
      else
          $("#about").fadeIn()

$('#clickme').click ->
  $('#book').animate {
    opacity: 0.25
    left: '+=50'
    height: 'toggle'
  }, 5000, ->
    # console.log 'do it'
    return
  return
