@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Image extends Entities.Model

  class Entities.ImageCollection extends Entities.Collection
    model: Entities.Image
    url: '/images'

  API =
    getImageEntities: (filter, cb) ->
      images = new Entities.ImageCollection()
      images.fetch
        data: filter
        success: ->
          # console.log images
          cb images

  App.reqres.setHandler "image:entities", (filter={}, cb) ->
    API.getImageEntities filter, cb
