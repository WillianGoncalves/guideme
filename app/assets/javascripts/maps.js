//= require underscore
//= require gmaps/google

var marker;

function initializeMap() {
  handler = Gmaps.build('Google');
  handler.buildMap({ provider: {}, internal: {id: 'map'}}, function(){
    //center on Rio de Janeiro
    handler.map.centerOn({ lat: -22.290052849751287, lng: -42.51389967103722 });

    //register click event
    google.maps.event.addListener(handler.getMap(), 'click', function(e){
      placeMarkerAndPanTo(e.latLng, handler.getMap());
    });
  });
}

function placeMarkerAndPanTo(latLng, map) {
  //remove previous marker
  if (marker) marker.setMap(null);

  //set new marker
  marker = new google.maps.Marker({
    position: latLng,
    map: map
  });
  map.panTo(latLng);

  $.ajax({
    url: "/guides/perform_search",
    data: { coordinates: [latLng.lat(), latLng.lng()], radius: $('#radius').val() }
  });
}

initializeMap();
