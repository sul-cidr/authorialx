@AL.module 'AuthorsApp.List', (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    startAuthors: ->
      # zap legend contents and hide
      $("#legend_list").html('')
      $("#legend_compare").addClass('hidden')
      $("#legend_base").removeClass('hidden')

      $(".btn").removeClass('disabled')

      if $("#image_modal").html() != ""
        $("#image_modal").dialog("close")

      # get all
      App.request "author:entities", (authors) =>
        # make hash
        window.authHash = new Array
        _.each authors.models, (a) =>
          authHash[a.attributes.author_id]={'fullname':a.attributes.prefname,"label":a.attributes.label}
        @layout = @getLayoutView()
        # console.log authors.models.length + ' authors'

        @layout.on "show", =>
          # AL.ContentApp.Show.Controller.showTab('authors')
          # @showTitle authors
          @listCatAuthors authors
          $("#spin_authors").addClass('hidden')

        App.authorsRegion.show @layout

    getLayoutView: ->
      new List.Layout

    listCatAuthors: (authors) ->
      authorsCatView = @getCatAuthorsView authors
      @layout.authorlistRegion.show authorsCatView

    getCatAuthorsView: (authors) ->
      new List.Authors
        collection: authors

    removeFilter: ->
      # console.log 'remove filter in controller'
      $("#selected_cat_authors").html('')
      # get all authors
      App.request "authors:category", {clear:true}, (authors) =>
        @listCatAuthors(authors)
        App.vent.trigger("map:reset", 'authors_list')
