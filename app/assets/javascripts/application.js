// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//

// *** from bower (i.e. vendor/components)

//= require jquery/dist/jquery.min
//= require underscore/underscore-min
//= require backbone/backbone-min
//= require backbone.marionette/lib/backbone.marionette.min

// require leaflet/dist/leaflet
//= require mapbox.js
//= require wellknown/wellknown
//= require leaflet-omnivore/leaflet-omnivore.min
//= require leaflet-active-area/src/leaflet.activearea
//= require leaflet.markercluster/dist/leaflet.markercluster
//= require Leaflet.MakiMarkers/Leaflet.MakiMarkers
//= require jquery-ui/jquery-ui.min

//= require typeahead.js/dist/typeahead.jquery.min
//= require typeahead.js/dist/bloodhound.min

//= require turf/turf
//= require crossfilter/crossfilter.min
//= require d3/d3.min
//= require js-cookie/src/js.cookie


// *** app

//= require_tree ./backbone/config
//= require backbone/app
//= require_tree ./backbone/entities
//= require_tree ./backbone/views
//= require_tree ./backbone/apps
//= require_tree ./backbone/helpers
//*** require turbolinks
//= require bootstrap-sprockets
//= require typekit
//= require ga_core
// require google_analytics
