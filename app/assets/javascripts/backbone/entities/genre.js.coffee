@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Genre extends Entities.Model

  class Entities.GenreCollection extends Entities.Collection
    model: Entities.Genre
    url: '/genres'

  API =
    getGenreEntities: (cb) ->
      # console.log Entities
      genres = new Entities.GenreCollection()
      genres.fetch
        success: ->
          # console.log 'genres', genres
          cb genres

  App.reqres.setHandler "genre:entities", (cb) ->
    # console.log 'in genre:entities'
    API.getGenreEntities cb
