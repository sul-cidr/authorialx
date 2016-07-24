
window.onload = function(){
  $("#site_title").html(settings.global.localeName);
  $(".tagline").html(settings.global.tagline);
}

function setCookie() {
  Cookies.set("al_splash","no-more")
  console.log(Cookies.get("al_splash"))
}

function scrollTo(hash) {
    location.hash = "#" + hash;
}

function loadPopup(placeid) {
  idToFeature.places[placeid].fireEvent("click")
}
function openPopup(placeid) {
  loadPopup(placeid)
  .then(
    idToFeature.places[placeid].openPopup());
}

// Disable function
jQuery.fn.extend({
    disable: function(state) {
        return this.each(function() {
            this.disabled = state;
        });
    }
});

function setTimer(name) {
  var i, output;
  i = void 0;
  output = '';
  console.time(name);
  i = 1;
  while (i <= 1e6) {
    output += i;
    i++;
  }
}

// returns value between 0 and 1;
// r = [min,max] of dataset
function scale(value,r) {
  return value * ( 1/(r[1] - r[0]) );
}

// returns value in ems suitable for font size
function scaleFont(value,range) {
  s = d3.scale.linear()
    .domain(range)
    .range([0.9,1.4]) // em
  return s(value);
}

// returns value in pixels suitable for circle markers
function scaleMarker(value,range) {
  // console.log('scaleMarker',value, range)
  // 2-step symbol size range
  newRange = range[1]<=4 ? [4,6] : [4,12]
  s = d3.scale.linear()
    .domain(range)
    .range(newRange) // em
    // .range([4,12])
  return s(value);
}

function colorizeFont(value,range) {
  // var ramp=d3.scale.linear().domain([0,100]).range(["red","blue"]);
  s = d3.scale.linear()
    .domain(range)
    .range(["#666","#a63603"]) // em
  return s(value);
}
function poetize(string) {
  return string.replace(/\/(?!span|p|i|em|b)/g,'<br/>');
}

function hardSpace(string){
  return string.replace(/ /g,'&nbsp;')
}

function swap(point) {
  point = [point[1], point[0]]
  return point
}

function createPolygonFromBounds(latLngBounds) {
  // var center = latLngBounds.getCenter()
    lnglats = [];

  lnglats.push([latLngBounds.getSouthWest().lng, latLngBounds.getSouthWest().lat]);//bottom left
  lnglats.push([latLngBounds.getNorthWest().lng, latLngBounds.getNorthWest().lat]);//top left
  lnglats.push([latLngBounds.getNorthEast().lng, latLngBounds.getNorthEast().lat]);//top right
  lnglats.push([latLngBounds.getSouthEast().lng, latLngBounds.getSouthEast().lat]);//bottom right
  lnglats.push([latLngBounds.getSouthWest().lng, latLngBounds.getSouthWest().lat]);//bottom left
  //
  // latlngs.push({ lat: latLngBounds.getSouth(), lng: center.lng });//bottom center
  // latlngs.push({ lat: center.lat, lng: latLngBounds.getEast() });// center right
  // latlngs.push({ lat: latLngBounds.getNorth(), lng: map.getCenter().lng });//top center
  // latlngs.push({ lat: map.getCenter().lat, lng: latLngBounds.getWest() });//center left

  return lnglats;
  // return new L.polygon(latlngs);
}

function cycleQuotes(){
      var $active = $('#cycler .active');
      var len = $active.html().length;
      // TODO: extends the fadeout period for longer passages
      // console.log('fade val will be',len*7)
      var $next = ($active.next().length > 0) ? $active.next() : $('#cycler div:first');
      $next.css('z-index',2);//move the next div up the pile
      $active.fadeOut(len*7,function(){ //fade out the top div
      // $active.fadeOut(1500,function(){ //fade out the top div
        $active.css('z-index',1).show().removeClass('active');//reset the z-index and unhide the div
          $next.css('z-index',3).addClass('active');//make the next div the top one
      });
    }
