@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Work extends Entities.Model
    idAttribute: "work_id"

  class Entities.WorkCollection extends Entities.Collection
    model: Entities.Work
    url: '/works'
    comparator: 'sorter'

  works = new Entities.WorkCollection()

  API =
    getWorkEntity: (workid, cb) ->
      work = works._byId[workid]
      cb work

    getWorkEntities: (cb) ->
      works.fetch
        success: ->
          # set a filter to leave out bio essays
          # (number bio works)
          filterBio = _.filter(works.models,(item) ->
            item.get("bio") == null;
          )
          works.reset(filterBio);
          cb works

    getWorksByAuthor: (authid, cb) ->
      # works = new Entities.WorkCollection()
      works.fetch
        success: ->
          filterId = _.filter(works.models,(item) ->
            item.get("author_id") == authid;
          )
          works.reset(filterId)
          cb works

    getWorksCategory: (filter, cb) ->
      # console.log 'API.getWorksCategory', filter
      works.fetch
        data: filter
        success: ->
          cb works


  App.reqres.setHandler "works:author", (authid, cb) ->
    API.getWorksByAuthor authid, cb

  App.reqres.setHandler "work:entity", (workid, cb) ->
    API.getWorkEntity workid, cb

  App.reqres.setHandler "work:entities", (cb) ->
    API.getWorkEntities cb

  App.reqres.setHandler "works:category", (filter={}, cb) ->
    API.getWorksCategory filter, cb
