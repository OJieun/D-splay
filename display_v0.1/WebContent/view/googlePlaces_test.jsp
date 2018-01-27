<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<style>
#google_map {width: 570px; height: 300px; margin-top: 10px; border: 1px solid darkgray;}
</style>
<script src="http://code.jquery.com/jquery-1.7.2.min.js"></script>
<script src="http://maps.google.com/maps/api/js?sensor=false&libraries=places"></script>
<script type="text/javascript">

$(document).ready(function(){
	$('#station_search_btn').click(function(event) {
		codeAddress();
	});
	initializeGoogleMap();
});

var map;
var service;

function initializeGoogleMap() {
	var seoul = new google.maps.LatLng(37.566535, 126.977969); 
 	map = new google.maps.Map(document.getElementById('google_map'), {
		mapTypeId : google.maps.MapTypeId.ROADMAP,
		center : seoul,
		zoom : 15
	});
}

function codeAddress() {
	var address = document.getElementById("station_search").value;
	var seoul = new google.maps.LatLng(37.566535, 126.977969);
	var request = {
		location : seoul,
		radius : '400',
		query : address
	};

	service = new google.maps.places.PlacesService(map);

	service.textSearch(request, function callback(results, status) {
		if (status == google.maps.GeocoderStatus.OK) {
			map.setCenter(results[0].geometry.location);
			
			var latitude = results[0].geometry.location.lat();
			var longitude = results[0].geometry.location.lng();
			var address = results[0].formatted_address;
			
			var LatLng = new google.maps.LatLng(latitude, longitude);
			map.setCenter(LatLng);
			$('#station_search').val(address);
			$('#station_location').val(latitude + ',' + longitude);
		}
	});
}

</script>
<body>
	<div id="station_address">
		역명<br> <input type="text" name="station_address" id="station_search" size="20">
		<input type="button" id="station_search_btn" value="검색">
		<input type="text" id="station_location" name="station_location">
		<div id="google_map"></div>
	</div>	
</body>
</html>