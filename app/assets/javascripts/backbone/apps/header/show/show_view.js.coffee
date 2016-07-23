@AL.module "HeaderApp.Show", (Show, App, Backbone, Marionette, $, _) ->


  class Show.Header extends App.Views.ItemView
    template: "header/show/templates/show_header"
    events:
      "click #home_link": "resetApp"
      "click #intro_link": "openSplash"
      "click #about_link": "loadAbout"
      "click #map_chooser li": "loadMap"
      "click i.fa-close": "loadAbout"

    loadAbout: (e)->
      ga('send', 'event', "banner", "click", "about")
      Show.Controller.loadAbout(e)

    openSplash: (e)->
      ga('send', 'event', "banner", "click", "introduction")
      AL.ContentApp.Show.Controller.openSplash()

    resetApp: ->
      ga('send', 'event', "banner", "click", "home")
      Backbone.history.navigate("/authors")
      window.location.reload()

    loadMap: (e) ->
      id = e.target.attributes.val.value
      ga('send', 'event', "select", "map", id)
      App.vent.trigger('map:swap', id);

  class Show.ModalView extends App.Views.ItemView
    template: "header/show/templates/show_modal"
    el: "#modal"
