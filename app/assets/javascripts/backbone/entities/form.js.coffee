@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Form extends Entities.Model

  class Entities.FormCollection extends Entities.Collection
    model: Entities.Form
    url: '/forms'

  API =
    getFormEntities: (cb) ->
      # console.log Entities
      forms = new Entities.FormCollection()
      forms.fetch
        success: ->
          # console.log 'forms', forms
          cb forms

  App.reqres.setHandler "form:entities", (cb) ->
    # console.log 'in form:entities'
    API.getFormEntities cb
