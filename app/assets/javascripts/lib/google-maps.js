function createPosition(lng, lat) {
	return {
		longitude: lng,
		latitude: lat
	};
}

function coordStringToArray(coordinates) {
	return [parseFloat(coordinates.split(' ')[0]), parseFloat(coordinates.split(' ')[1])];
}

function createGoogleMap(element, center, zoom, visibility) {
	return new google.maps.Map(element, {
		center: center,
		zoom: zoom,
		styles: [
			{
				featureType: 'poi.business',
				elementType: 'labels',
				stylers: [
					{ visibility: visibility }
				]
			}
		]
	});
}

function positionToGoogleLatLng(position) {
	return new google.maps.LatLng(
		position.latitude,
		position.longitude
	);
}

function addMarker(map, centerGoogleLatLng, title, optimized, draggable) {
	return new google.maps.Marker({
		map: map,
		position: centerGoogleLatLng,
		animation: google.maps.Animation.DROP,
		title: title,
		optimized: optimized,
		draggable: draggable
	});
}

function getGeocodefromGoogleMaps(address, idx, callback) {
	new google.maps.Geocoder().geocode({
		'address': address
	}, function(results, status) {
		if (status == google.maps.GeocoderStatus.OK) {
			callback(results[0], idx);
		} else {
			callback({}, idx);
		}
	});
}

function renderMap(center, zoom, editable) {
	var addressMap = document.getElementById('address-map');
	var map = createGoogleMap(addressMap, center, zoom, editable ? 'on' : 'off');
	if(editable) {
		setAddressCoordinates
		.call(addMarker(map, center, title, optimized, editable))
		.addListener('dragend', setAddressCoordinates);
		var formMapContainer = $("#form-map-container");
		formMapContainer.append("<h5><small>Drag the marker if it is at wrong location.</small></h5>");
	} else {
		addMarker(map, center, title, optimized, editable);
	}
}

function populateInfoWindow(marker, map, infowindow, result) {
	if(infowindow.marker != marker) {
		infowindow.marker = marker;
		infowindow.setContent(infoWindowContent(result));
		infowindow.open(map, marker);
		infowindow.addListener('closeclick', function() {
			infowindow.setMarker = null;
		});
	}
	modifyInfoWindow();
}

function modifyInfoWindow() {
	var iwOuter = $('.gm-style-iw');
	var iwBackground = iwOuter.prev();
	iwBackground.css({'display' : 'none'});

	var iwCloseBtn = iwOuter.next();

	iwCloseBtn.css({
		opacity: '1',
		right: '19px',
		top: '30px',
	});
}

function resultMap(results) {
	if(window.markers)
	{
		for (var i = 0; i < window.markers.length; i++) {
			window.markers[i].setMap(null);
		}
	}
	window.markers = [];

	var bounds = new google.maps.LatLngBounds();
	bounds.extend(window.centerSpot.position);

	var largeInfoWindow = new google.maps.InfoWindow();

	results.forEach(function(result, index) {
		var markerCoordArray = coordStringToArray(result.coordinates);
		var markerPosition = createPosition(markerCoordArray[0], markerCoordArray[1]);
		var markerGooglePosition = positionToGoogleLatLng(markerPosition);
		var marker = addMarker(window.googleMap, markerGooglePosition, result.name, optimized, false);
		bounds.extend(marker.position);
		marker.addListener('click', function() {
			populateInfoWindow(this, window.googleMap, largeInfoWindow, result);
		});
		window.markers.push(marker);
	});
	window.googleMap.fitBounds(bounds);
}
