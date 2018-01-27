<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>전시 목록 페이지</title>
<link rel="stylesheet" type="text/css" href="${initParam.root }css/sub.css">
<script src="http://maps.google.com/maps/api/js?sensor=false&libraries=places"></script>
<script src="http://code.jquery.com/jquery-1.7.2.min.js"></script>
<script src="http://code.jquery.com/jquery-migrate-1.1.0.js"></script>
<script type="text/javascript">
//전철역의 위도경도를 받아 ajax로 검색하는 함수
	function search_by_location(latitude, longitude){
		$.ajax({
			type:"GET",
			url:"search_by_location.do",
			dataType: "xml",
			data:{latitude:latitude, longitude:longitude},
			success: function(xml){
				var xmlData = $(xml).find("response").find("msgBody").find("perforList");
	            var listLength = xmlData.length;
				alignResult(xmlData, listLength);
			}
		});
	}
//-------- -------------위,경도 받아오는 부분------------------------------------
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
				
				var LatLng = new google.maps.LatLng(latitude, longitude);
				//map.setCenter(LatLng);
				console.log("codeAddress 함수 : LatLng - " + LatLng + " /latitude - " + latitude + " /longitude - " + longitude);
				
				//위도 경도를 검색하는 함수에 넘겨주어 바로 검색 실행
				search_by_location(latitude, longitude);
			}
		});
	}
//------------------------------위.경도 끝------------------------------
    var g_seq = '';
	function goView(seq){
      //alert(seq);
      	 
      $.ajax({
         type:"GET",
         url:"toView.do", 
         dataType: "xml",
         data: {seq:seq},
         success: function(data){
        	 var xmlData = $(data).find("response").find("msgBody").find("perforInfo");
        	 var listLength = xmlData.length;
        	 
        	 var content = '';
        	 var poster = '';
        	 var place = '';
        	 for(var i=0; i<listLength; i++){
        		poster += '<img src="'+$(data).eq(i).find('imgUrl').text()+'" alt="poster" width="167px" height="245px">';
        		content += $(data).eq(i).find('title').text();
        		place += $(data).eq(i).find('realmName').text()+" | "+$(data).eq(i).find('startDate').text()+" ~ "+$(data).eq(i).find('endDate').text()+'<br><br>';
        		place += "장소 | "+$(data).eq(i).find('place').text()+" ("+$(data).eq(i).find('area').text()+")";
        	 }
        	 $('#display_info_title').empty().append(content);
        	 $('#display_poster').empty().append(poster);
        	 $('#display_info_content').empty().append(place);
        	 g_seq = seq;
        	 }
      	});
  	 }
  	 
  	 // 상세 페이지로 이동
      function FromView(){
         location.href='view.do?seq='+g_seq;
      }
</script>
</head>
<body>
	<div id="wrapper">
		<div id="header">
			<div id="logo">
				<a href="main.do"><img alt="메인으로" src="images/logo.png"></a>
			</div>
			<div id="global_menu">
				<a href="search.do"><img alt="검색하기" src="images/search.png"></a>
			</div>
		</div>
		<div id="body">
			<div id="left_content">
				<%-- 전시회 목록 --%>
				<div id="left_content_title"></div>
				<div id="left_content_list">
					<c:forEach items="${list}" var="anItem">
						<div id="left_content_list_subject">
							<a href="#" onclick="goView(${anItem.seq})" style="text-decoration: none; color: white;">${anItem.title }</a>
						</div>
					</c:forEach>
				</div>
			</div>
			<div id="right_content">
				<div id="right_content_title"></div>
				<div id="right_content_body">
					<div id="search_result_area"></div>
					<div id="display_poster"></div>
					<div id="display_info">
						<%-- 해당 전시의 전시 정보 --%>
						<div id="display_info_title"></div>
						<div id="display_info_content"></div>
						<input type="button" value="" class="display_info_btn" onclick="FromView()">
					</div>
				</div>
			</div>
		</div>
		<div id="footer">footer</div>
	</div>

	<span id="addressView"></span>
	<%-- 
	<div>${totalCount }개</div>
	<c:forEach items="${list}" var="anItem">
		<div>순번 : ${anItem.seq }</div>
		<div>타이틀 : ${anItem.title }</div>
		<div>시작일 : ${anItem.startDate }</div>
		<div>끝일 : ${anItem.endDate }</div>
		<div>썸네일 : ${anItem.thumbnail }</div>
		<div>장소 : ${anItem.place }</div>
		<div>--------------------------</div>
	</c:forEach> --%>
</body>
</html>