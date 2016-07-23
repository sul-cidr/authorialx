@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.User extends Entities.Model

  class Entities.UserCollection extends Entities.Collection
    model: Entities.User
    # url: Routes.users_path()

  API =
    setCurrentUser: (currentUser) ->
      new Entities.User currentUser

    getUserEntities: (cb) ->
      # console.log Entities
      users = new Entities.UserCollection()
      users.fetch
        success: ->
          cb users


  App.reqres.setHandler "set:current:user", (currentUser) ->
    API.setCurrentUser currentUser

  App.reqres.setHandler "user:entities", (cb) ->
    API.getUserEntities cb
