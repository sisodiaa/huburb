$(document).ajaxError(function( event, jqxhr, settings, thrownError ) {
	clearAlerts();

  if(settings.url.search(/\/users\/sign_in/) >= 0) {
		addAlert("warning", jqxhr.responseText);
	}
});
