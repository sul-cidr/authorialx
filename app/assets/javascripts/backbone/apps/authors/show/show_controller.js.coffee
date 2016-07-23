@AL.module 'AuthorsApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    showAuthor: (author) ->
      # if App.request("authors:checked").length > 0
      #   console.log 'authors:checked',App.request("authors:checked")

      # disable dimension dropdowns
      $(".btn").addClass('disabled')
      authid = author.get("author_id")
      prefname = author.get("prefname")
      surname = author.get("surname")
      @authorLayout = @getAuthorLayout author

      ga('send', 'pageview', author.get("label"));

      @authorLayout.on "show", =>
        @showTitle author
        @showNav author
        @listBioPassages author
        @showGallery authid

        $("#author_crumbs").append(
          '<span id="crumb_author" class="crumb-left" val="'+authid+'">:: '+surname+
          ' :: Biography'+
          '</span>')
        $("#spin_authors").addClass('hidden')

      App.authorsRegion.show @authorLayout

      # trigger for map_app
      App.vent.trigger "authors:show", authid

    showGallery: (authid) ->
      $("#gallery_region").removeClass("hidden")
      App.request "image:entities", {author_id: authid}, (images) =>
        galleryView = @getGalleryView images
        App.galleryRegion.show galleryView

      # $("#thumb_gallery").html('<h3>Photos for '+author.get("prefname")+"</h3>")

    getGalleryView: (images) ->
      new Show.ImageList
        collection: images

    getAuthorLayout: (author) ->
      new Show.Layout ({
        model: author
      })

    showImageModal: (imageid) ->
      alert "The larger version is not available yet, sorry!"

    listBioPassages: (author) ->
      id = author.get("author_id")

      App.request "passage:entities", id, "bio", (bio_passages) =>
        # console.log bio_passages
        # wont show/render twice without reset
        if App.authorContentRegion.$el.length > 0
          App.authorContentRegion.reset()

        bioPassagesView = @getBioPassagesView bio_passages, 'bio'
        # console.log 'listBioPassages(), '+ bio_passages.length + ' for ' + author_id
        window.passb = bioPassagesView
        # bioauthor = workHash[passb.collection.models[0].attributes.work_id].author_id
        # console.log 'bioauthor is ' + if bioauthor == 10438 then 'Kenny' else 'Martin'
        # expose for disambiguating placeref selection on click
        App.reqres.setHandler "activework:id", ->
          return passb.collection.models[0].attributes.work_id
        console.log('listBioPassages work_id',passb.collection.models[0].attributes.work_id)

        App.authorContentRegion.show bioPassagesView

    getBioPassagesView: (bio_passages, type) ->
      new Show.Passages
        collection: bio_passages
        viewComparator: "passage_id"
        className: 'passages-bio'

    listWorks: (author) ->
      id = author.get("author_id")
      # console.log 'listWorks()', id
      App.request "works:author", id, (works) =>
        # console.log 'listWorks() '+ id, works
        if App.authorContentRegion.$el.length > 0
          App.authorContentRegion.reset()
        @worksView = @getWorksView works
        window.works = works
        # get work_ids
        window.work_ids = []
        _.each works.models, (w) =>
          work_ids.push w.attributes.work_id
        App.authorContentRegion.show @worksView

    getWorksView: (works) ->
      new Show.Works
        collection: works
        viewComparator: "sorter"

    listWorkPassages: (work) ->
      id = work.get("work_id")
      title = work.get("title")
      # console.log 'Show.Controller.listWorkPassages() for',work_id
      App.request "passage:entities", id, "work", (work_passages) =>
        # wont show/render twice without reset
        if App.authorContentRegion.$el.length > 0
          App.authorContentRegion.reset()
        workPassagesView = @getWorkPassagesView work_passages, 'works'
        # console.log 'listWorkPassages(), '+ work_passages.length + ' for ' + id
        App.authorContentRegion.show workPassagesView
        # TODO: show Passages tab if it was hidden
        $("#passages_pill").removeClass("hidden")
        $(".work-title").html('from <em>'+title+'</em')

    getWorkPassagesView: (work_passages, type) ->
      new Show.Passages ({
        collection: work_passages
        viewComparator: "passage_id"
        className: 'passages-works'
      })


    showTitle: (author) ->
      @titleView = @getTitleView author
      @authorLayout.titleRegion.show @titleView

    getTitleView: (author) ->
      new Show.Title
        model: author

    showNav: (author) ->
      @navView = new Show.Pills
        model: author
      @authorLayout.navRegion.show @navView
