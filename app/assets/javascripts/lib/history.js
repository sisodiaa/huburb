function bindNavigationLink() {
	$('div#navigation-links a[data-remote=true]').click(function(event) {
		 history.pushState(null, "", $(this).attr("href"));
	});

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
