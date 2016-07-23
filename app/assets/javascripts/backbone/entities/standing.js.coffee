@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Standing extends Entities.Model

  class Entities.StandingCollection extends Entities.Collection
    model: Entities.Standing
    url: '/standings'

  API =
    getStandingEntities: (cb) ->
      # console.log Entities
      standings = new Entities.StandingCollection()
      standings.fetch
        success: ->
          # console.log 'standings', standings
          cb standings

  App.reqres.setHandler "standing:entities", (cb) ->
    API.getStandingEntities cb
