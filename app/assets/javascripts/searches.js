// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

document.addEventListener("turbolinks:load", function() {
	if(!window.userLocation) {
		getCoordinates(setCoordinatesField);
	} else {
    node = document.getElementById('search-overlay');
    if (node !== null) {
      node.parentElement.removeChild(node);
    }
	}

	function getCoordinates(callback) {
		navigator.geolocation.getCurrentPosition(function(position) {
			callback(position.coords.longitude, position.coords.latitude);
		}, function(error) {
			callback(77.3675733, 28.5449357);
		});
	}

	function setCoordinatesField(longitude, latitude) {
		window.userLocation = { longitude: longitude, latitude: latitude };
		//$('input#coordinates').val('POINT(' + longitude + ' ' + latitude + ')');
		//	$('input#coordinates_longitude').val(longitude);
		//$('input#coordinates_latitude').val(latitude);
		$.ajax({
			url: '/search',
			type: "POST",
			data: { longitude: longitude.toFixed(6), latitude: latitude.toFixed(6) },
			success: function(response) {
				node = document.getElementById('search-overlay');
				if (node !== null) {
          node.parentElement.removeChild(node);
				}
      },
      error: function(jqXHR, textStatus, errorThrown) {
        $.ajax({
          url: '/demo/search',
          type: 'POST',
          data: { longitude: longitude.toFixed(6), latitude: latitude.toFixed(6) },
          success: function(response) {
            node = document.getElementById('search-overlay');
            if (node !== null) {
              node.parentElement.removeChild(node);
            }
          },
          error: function(jqXHR, textStatus, errorThrown) {
            addAlert("warning", "Location not set");
          }
        });
      }
		});
	}

	if(document.body.id == 'searches_show') {
		var results = $('div#search-results').data('results');
		if(results.length != 0) {
			var addressMap = document.getElementById('address-map');
			var optimized = !$('#address-map').data("environment");
			var coordArray = coordStringToArray($('#address-map').data("coordinates"));
			var position = createPosition(coordArray[0], coordArray[1]);

			var center = positionToGoogleLatLng(position);
			var map = createGoogleMap(addressMap, center, 15, 'off');
			window.googleMap = map;

			window.centerSpot = new google.maps.Marker({
				position: center,
				title: "Your location",
				icon: {
					path: google.maps.SymbolPath.CIRCLE,
					strokeColor: 'DeepSkyBlue',
					scale: 4,
					strokeWeight: 8
				},
				map: map
			});

			resultMap(results);

			$('div.result-row a')
			.mouseenter(function() {
				var resultRow = $(this).parent();
				var index = resultRow.data("index");
				markers[index].setIcon({
					url: 'https://maps.gstatic.com/mapfiles/api-3/images/spotlight-poi_hdpi.png',
					scaledSize: new google.maps.Size(22, 40)
				});
				markers[index].setAnimation(google.maps.Animation.BOUNCE);
			})
			.mouseleave(function() {
				var resultRow = $(this).parent();
				var index = resultRow.data("index");
				markers[index].setIcon('https://maps.gstatic.com/mapfiles/api-3/images/spotlight-poi_hdpi.png');
				markers[index].setIcon({
					url: 'https://maps.gstatic.com/mapfiles/api-3/images/spotlight-poi_hdpi.png',
					scaledSize: new google.maps.Size(22, 40)
				});
				markers[index].setAnimation(null);
			});
		}
		bindNavigationLink();
	}
});

$(window).on('popstate', function () {
	$.getScript(document.location.href);
});
