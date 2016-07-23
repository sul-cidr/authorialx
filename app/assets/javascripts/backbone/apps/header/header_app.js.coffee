@AL.module "HeaderApp", (HeaderApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API =
    showHeader: ->
      HeaderApp.Show.Controller.showHeader()

    showModal: ->
      HeaderApp.Show.Controller.showModal()

  HeaderApp.on "start", ->
    controller: API
    API.showHeader()
