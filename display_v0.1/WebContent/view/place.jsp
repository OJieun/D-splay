<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<style>
#content{height: auto; width: 800px; margin : 20px 0 0 30px;}
#title{height: 40px; font-family: '맑은 고딕';}
	#place{font-weight: bold; font-size:17pt;}
	#name{font-size: 13pt; color: #747474;}

#placeInfo{width: 700px; height:70px;  border: 2px solid #A6A6A6; font-family: '맑은 고딕'; margin : 20px 0;}
	#addr, #url{width: 630px; float: left; height: 30px; margin:3px 0;}
	.info_name{float:left; width: 50px; height: 30px; margin:3px 0 0 10px; }
#google_map{width: 700px; height: 400px;}
</style>
<script src="http://code.jquery.com/jquery-1.7.2.min.js"></script>
<script src="http://maps.google.com/maps/api/js?sensor=false&libraries=places"></script>
<script type="text/javascript">
$(document).ready(function(){
	initializeGoogleMap();
});

function initializeGoogleMap() {
	var destination = new google.maps.LatLng($('#gpsY').val(), $('#gpsX').val()); 
 	var map = new google.maps.Map(document.getElementById('google_map'), {
		mapTypeId : google.maps.MapTypeId.ROADMAP,
		center : destination,
		zoom : 17
	});
	new google.maps.Marker({
		map : map,
		icon : "images/map_marker.png",
		position : destination
	});
}


</script>
<body>
<input type="hidden" id="gpsX" value="${gpsX }">
<input type="hidden" id="gpsY" value="${gpsY }">
<div id="content">
	<div id="title"><span id="place">${place }</span><span id="name"> - ${title }</span></div>
	<div id="google_map"></div>
	<div id="placeInfo">
		<div class="info_name">주소</div><div id="addr">${placeAddr }</div>
		<div class="info_name">웹</div><div id="url"><a href="${placeUrl }">${placeUrl }</a></div>
	</div>

</div>

</body>
</html>