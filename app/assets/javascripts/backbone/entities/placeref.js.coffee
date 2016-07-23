@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Placeref extends Entities.Model
    idAttribute: "placeref_id"
    url: '/placerefs/:placeref_id'

  class Entities.PlacerefCollection extends Entities.Collection
    model: Entities.Placeref
    url: '/placerefs'

  # placerefs = new Entities.PlacerefCollection()

  API =
    # all placerefs less bio not yet mapped to author/work
    getPlacerefEntities: (data, cb) ->
      # console.log 'getPlacerefEntities', data
      placerefs = new Entities.PlacerefCollection()
      placerefs.fetch
        data: data
        success: ->
          cb placerefs

  App.reqres.setHandler "placeref:entities", (data={},cb) ->
    API.getPlacerefEntities data, cb
