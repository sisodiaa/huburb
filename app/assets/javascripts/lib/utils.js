function addAlert(context, message) {
	$('div#content-container')
	.prepend("<div class='alert alert-" + context + " alert-dismissible' role='alert'></div>");
	var alert = $('div.alert');
	alert.prepend("<button class='close' data-dismiss='alert'></button");
	alert.append(message);

	var alertButton = $('div.alert button.close');
	alertButton.prepend("<span aria-hidden='true'>x</span>");
	alertButton.append("<span class='sr-only'>Close</span>");
}

function clearAlerts() {
	$('div.alert').remove();
}

function infoWindowContent(data) {
	var title = "<div class='iw-title text-center'><h5>" + data.name + "</h5></div>";
	var category = '<h6>' + data.category + '</h6>';
	var link = "<a href='" + data.link + "' class='btn btn-xs btn-default btn-block'>View</a>";
	return("<div id='iw'><div id='iw-container'>" + title + category + link + "</div></div>");
}
