// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

document.addEventListener("turbolinks:load", function() {
	var addressMap = document.getElementById('address-map');
	if(addressMap && (document.body.id == 'pages_show')) {
		var coordinates = $('#address-map').data("coordinates").split(' ');
		var optimized = !$('#address-map').data("environment");
		var title = $('#address-map').data("title");
		var position = createPosition(parseFloat(coordinates[0]), parseFloat(coordinates[1]));

		var center = positionToGoogleLatLng(position);
		
		var map = createGoogleMap(addressMap, center, 15, 'off');

		addMarker(map, center, title, optimized, false);
	}

  if(document.body.id == 'pages_show') {
    if(document.getElementById('chat-panel-messages')) {
      $('div#chat-panel-messages').animate({scrollTop: $('div#chat-panel-messages').prop('scrollHeight')}, 0);
    }
  }
});
