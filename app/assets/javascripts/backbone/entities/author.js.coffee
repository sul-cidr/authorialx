@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Author extends Entities.Model
    idAttribute: "author_id"
    url: '/authors/:author_id'

  class Entities.AuthorCollection extends Entities.Collection
    model: Entities.Author
    url: '/authors'
    comparator: 'surname'
    # CHECK is idAttribute any use?
    idAttribute: "author_id"

  authors = new Entities.AuthorCollection

  author = new Entities.Author

  API =

    getAuthorEntities: (cb) ->
      authors.fetch
        success: ->
          cb authors

    getAuthorEntity: (id, cb) ->
      authors.fetch
        success: ->
          @author = authors._byId[id]
          cb @author

    # TODO this executes twice, from authors_app and map_app
    getAuthorsCategory: (filter, cb) ->
      # console.log 'API.getAuthorsCategory', filter
      authors.fetch
        data: filter
        success: ->
          cb authors

  App.reqres.setHandler "author:entities", (cb) ->
    API.getAuthorEntities cb

  App.reqres.setHandler "author:entity", (id, cb) ->
    API.getAuthorEntity id, cb

  App.reqres.setHandler "authors:category", (filter={}, cb) ->
    API.getAuthorsCategory filter, cb
