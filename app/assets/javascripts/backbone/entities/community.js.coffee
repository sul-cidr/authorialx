@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Community extends Entities.Model

  class Entities.CommunityCollection extends Entities.Collection
    model: Entities.Community
    url: '/communities'

  API =
    getCommunityEntities: (cb) ->
      # console.log Entities
      communities = new Entities.CommunityCollection()
      communities.fetch
        success: ->
          # console.log 'communities', communities
          cb communities

  App.reqres.setHandler "community:entities", (cb) ->
    # console.log 'in community:entities'
    API.getCommunityEntities cb
