// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var geocodes = {};
var optimized;
var title;

function setAddressCoordinates() {
	var markerPosition = this.getPosition();
	$('#address_coordinates').val(markerPosition.lng().toFixed(6) + ' ' + markerPosition.lat().toFixed(6));
	return this;
};

function addGeocode(result, idx, callback) {
	geocodes[idx] = result;
	if(Object.keys(geocodes).length === 4) {
		callback();
	}
}

function prepareMap() {
	var i = 0;
	for(; i < 4; i++ ) {
		if(!$.isEmptyObject(geocodes[i])) {
			var result = geocodes[i];
			var location = result.geometry.location;
			var position  = createPosition(location.lng(), location.lat());
			var center = positionToGoogleLatLng(position);

			$('#address-new-form').removeClass('col-md-offset-3 card').addClass('col-md-pull-6');
			$('#form-map-container').addClass('col-md-6 col-md-push-6');
			$('#form-map-container').parent().addClass('card margin-bottom-15');
			$('#form-map-container').append("<div id='address-map'></div>");

			renderMap(center, 17, true);

			$("input[value='Create Address']").show();
			$("input[value='Locating...']").remove();
			$("form h5").remove();
			break;
		}
	}
	geocodes = {};
	if(i == 4) {
		addAlert("warning", "Unable to locate, provide a detailed address.");
		$("input[value='Locating...']").prop("disabled", false);
		$("input[value='Locating...']").attr('value', 'Locate on Map');
	}
}

function drawMap(username, test) {
	if($('div#address-map')) {
		$('div#form-map-container').empty();
	}
	title = username;
	optimized = test;
	var addresses = [];
	var form = document.getElementById('new_address') || document.getElementsByClassName('edit_address')[0];
	var addressArray = [];
	for(var i = 2; i < 8; i++) {
		var e = form.elements[i];
		if(e.value) {
			addressArray.push(e.value);
		}
	}
	
	if(addressArray.length != 0) {
		addresses = [];
		addresses.push(addressArray.join(', '));
		addresses.push(addressArray.slice(0, 5).join(', '));
		addresses.push(addressArray.slice(1, 5).join(', '));
		addresses.push(addressArray.slice(2, 5).join(', '));

		addresses.forEach(function(address, idx) {
			getGeocodefromGoogleMaps(address, idx, function(result, idx) {
				addGeocode(result, idx, prepareMap);
			});
		});
	}
}

document.addEventListener("turbolinks:load", function() {
	if(document.body.id == 'addresses_edit') {
		var coordinates = $('#address-map').data("coordinates").split(' ');
		var optimized = !$('#address-map').data("environment");
		title = $('#address-map').data("title");
		var position = createPosition(parseFloat(coordinates[0]), parseFloat(coordinates[1]));
		var center = positionToGoogleLatLng(position);

		renderMap(center, 17, true);
	}
});
