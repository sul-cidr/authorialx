@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Place extends Entities.Model
    idAttribute: "place_id"

  class Entities.PlaceCollection extends Entities.Collection
    model: Entities.Place
    url: '/places'
    idAttribute: "place_id"

  # places = new Entities.PlaceCollection()

  API =
    getPlaceEntities: (filter, cb) ->
      places = new Entities.PlaceCollection()
      places.fetch
        data: filter
        success: ->
          # console.log 'filtered places,', places
          cb places

    getPlaceEntity: (pid, cb) ->
      places = new Entities.PlaceCollection()
      places.fetch
        success: ->
          @place = places._byId[pid.to_i]
          # console.log '@place', @place
          cb @place


  App.reqres.setHandler "place:entities", (filter={}, cb) ->
    # console.log 'API.getPlaceEntities filter', filter
    API.getPlaceEntities filter, cb

  App.reqres.setHandler "place:entity", (pid, cb) ->
    # console.log 'API.getPlaceEntity pid', pid
    API.getPlaceEntity pid, cb
