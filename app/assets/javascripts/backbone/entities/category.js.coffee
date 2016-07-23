@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Category extends Entities.Model

  class Entities.CategoryCollection extends Entities.Collection
    model: Entities.Category
    url: '/categories'

  API =
    getCategoryEntities: (cb) ->
      # console.log Entities
      categories = new Entities.CategoryCollection()
      categories.fetch
        success: ->
          cb categories

  App.reqres.setHandler "category:entities", (cb) ->
    API.getCategoryEntities cb
