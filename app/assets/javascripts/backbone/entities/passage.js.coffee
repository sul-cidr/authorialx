@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Passage extends Entities.Model
    idAttribute: "passage_id"

  class Entities.PassageCollection extends Entities.Collection
    model: Entities.Passage
    url: '/passages'
    idAttribute: "passage_id"

  class Entities.PassageResultsCollection extends Entities.Collection
    model: Entities.Passage
    url: "/search.json"
    idAttribute: "passage_id"

  # passages = new Entities.PassageCollection

  API =
    # search for string 'q'
    searchPassages: (q, cb) ->
      # console.log 'entities.passage.searchPassages()', q

      # execute a search, returns collection of models
      passages = new Entities.PassageResultsCollection

      passages.fetch({
        data: {q: q}
        processData: true

        success: ->
          filterOutBio = _.filter(passages.models,(item) ->
            item.get("work_id") > 20399
          )
          passages.reset(filterOutBio)
          cb passages

      })

    getPassageEntities: (id, type, cb) ->
      # console.log 'getPassageEntities', id, type
      passages = new Entities.PassageCollection
      passages.fetch
        success: ->
          filterBio = _.filter(passages.models,(item) ->
            item.get("subject_id") == id;
          )
          # passages.reset(filterBio)
          filterWorks = _.filter(passages.models,(item) ->
            item.get("work_id") == id;
          )
          if type == "bio"
            passages.reset(filterBio)
            cb passages
          else if type == "work"
            passages.reset(filterWorks)
            cb passages


    getPlacePassages: (passage_ids, cb) ->
      # console.log 'API.getPlacePassages', passage_ids
      placePassages = new Entities.PassageCollection
      placePassages.fetch
        success: ->
          # console.log placePassages
          filter = _.filter(placePassages.models,(item) ->
            passage_ids.indexOf(item.get("passage_id")) > -1
          )
          placePassages.reset(filter)
          cb placePassages

    getPlacerefPassages: (placeref_id, cb) ->


    getPlacePassage: (passage_id, cb) ->
      # console.log 'API.getPlacePassage (one)', passage_id
      placePassages = new Entities.PassageCollection
      placePassages.fetch
        success: ->
          # console.log placePassages
          filter = _.filter(placePassages.models,(item) ->
            passage_id == item.get("passage_id")
          )
          placePassages.reset(filter)
          cb placePassages

  App.reqres.setHandler "passage:entities", (id, type, cb) ->
    API.getPassageEntities id, type, cb

  App.reqres.setHandler "passages:place", (passage_ids, cb) ->
    API.getPlacePassages passage_ids, cb

  App.reqres.setHandler "passages:placeref", (placeref_id, cb) ->
    API.getPlacerefPassages placeref_id, cb

  # gets one from link in place popup
  App.reqres.setHandler "passage:place", (passage_id, cb) ->
    API.getPlacePassage passage_id, cb

  App.reqres.setHandler "passages:search", (q, cb) ->
    API.searchPassages q, cb
