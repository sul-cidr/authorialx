@AL.module "WorksApp", (WorksApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  class WorksApp.Router extends Marionette.AppRouter

  API =
    startWorks: ->
      # console.log 'API.startWorks fired'
      AL.WorksApp.List.Controller.startWorks()


  WorksApp.on "start", ->
    new WorksApp.Router
      controller: API
