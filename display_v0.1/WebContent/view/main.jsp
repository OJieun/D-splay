<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Welcome To D:splay :)</title>
<link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css" rel="stylesheet" type="text/css"/>

</head>
<style>
*{margin:0px;}
#station_address{display:none;}
#wrapper {width:100%; height: auto; float: left;}
#header{width:100%; height:102px;  background: url("images/header.png"); float: left;}
#logo{width: 168px; height: 46px; float: left; margin-left: 33px; margin-top: 30px;}
#global_menu{width:58px; height: 16px; float:left; margin-left: 78%; margin-right: 34px; margin-top: 43px;}
#footer{width:100%; height: 88px; background: url("images/footer.png"); float: left; margin-top: 30px;}

#main_contents{width:100%; height:auto; float: left;}
	#popular_display{ width:100%; height : 400px; margin : 0 auto; background: url("images/popular_background.png") ; float: left;}
		#poster_binder{width:100%; float: left; margin-left: 13%; }
		.popular_poster{width: 138px; height: 200px; background-color:#5E5E5E; float: left; margin : 100px 2% 0 2%;}
	#select_categories{margin:20px 0 100px 30px; float:left; width: 80%; height : auto;}
		#select_category_txt{font-family: '맑은 고딕'; font-size: 16pt;}
		#categories_div{width:100%; height : auto; margin :15px auto; font-family: '맑은 고딕'; font-size: 12pt; float: left;}
			#genre_div, #order_div, #station_div{width:250px; height:40px; margin-right: 8%; line-height : 40px; background-color:#d7d7d7; text-align: center; float: left;}
			#order_div{margin-right:4%;}
				#station_search_btn{width:30px; height: 30px; text-align: center; cursor: pointer; line-height: 30px; float: right; margin : 5px 8px 0 0;}
				#station_search_key{width : 110px; height: 25px; font-weight: bold; line-height: 40px; float: left; margin : 5px 0 0 8px;}
				.category_name{font-weight: bold; float: left; width : 70px;}
				.name_align{margin-left : 10px;}
				select{width : 100px; height: 30px; line-height: 30px; font-family: '맑은 고딕'; font-size: 11pt;}
			#submit_category{width : 80px; height : 40px; line-height :30px; float: left; background: url("images/main_search.png") repeat scroll 0 0 rgba(0, 0, 0, 0); border: 0px;}
				
		#station_search_result_section{width:250px; height: auto; float: left;}
			.aStation_input{float: left; margin : 7px 0 0 10px;}
			.not_searched{width: 100%; height: 30px; text-align: center; color :#003399; font-weight: bold;}
			#searched_stations{width : 250px; height : auto; float: left;}
			.aStation{width : 100%; float:left; height : 25px; line-height:25px; }
			.station_name{font-weight: bold; font-size: 11pt; height: 25px;  line-height:25px; float: left; margin-left : 10px;}
			.line_num{color : #8C8C8C; font-size: 9pt; height: 25px; line-height:25px; float: left; margin-left : 10px;}
</style>
<script src="http://code.jquery.com/jquery-1.7.2.min.js"></script>
<script src="http://maps.google.com/maps/api/js?sensor=false&libraries=places"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>

<script type="text/javascript">
	var genreComp;
	function startRequest(){
		genreComp = document.getElementById("select_genre");
		if(genreComp.value==""){
			alert("전시 장르를 선택하세요.");
			return;
		}
	}
	
	$(document).ready(function(){
		initializeGoogleMap();
		
		var clareCalendar = {
				   monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
				   dayNamesMin: ['일','월','화','수','목','금','토'],
				   weekHeader: 'Wk',
				   dateFormat: 'yymmdd', //형식(20120303)
				   autoSize: false, //오토리사이즈(body등 상위태그의 설정에 따른다)
				   changeMonth: true, //월변경가능
				   changeYear: true, //년변경가능
				   showMonthAfterYear: true, //년 뒤에 월 표시
				   yearRange: '1990:2020' //1990년부터 2020년까지
				  };
				  $("#startDate").datepicker(clareCalendar);
				  $("#endDate").datepicker(clareCalendar);
			  
		//지하철 역 검색 버튼 클릭 시 or 엔터 눌렀을 때
		$("body").on('click', '#station_search_btn', function(){
			
			var keyword = $('#station_search_key').val();
			
			//검색어가 두 글자 이상일 때 검색 실행.
			if(keyword.length>=2){					
				
				//지하철명 정보를 가진 json 파일과 비교, 검색
	 			$.ajax({
					type:"GET",
					url:"data/subway_name_search.json",
					dataType: "json",
					success:function(json){
						var station_list = json.DATA;
						var contentStr = '<div id="searched_stations">';
						var listLen = station_list.length;
						var count=0; //검색된 역 갯수 카운트
						
						if(listLen>0){//검색 결과가 있을 때 실행
			                for(var i=0; i<listLen; i++){
								if(station_list[i].STATION_NM.match(keyword)){
									count++;
									contentStr += '<div class="aStation"><input type="radio" class="aStation_input" id="station'+i+'" name="station_val" value="'+station_list[i].STATION_CD+'">';
									contentStr += '<span class="station_name">'+station_list[i].STATION_NM+'</span><span class="line_num">'+station_list[i].LINE_NUM+'호선</span></div>';
								}                   
			                }
			                contentStr += '</div>';
			                $("#station_search_result_section").empty().append(contentStr);
			               
			                //라디오버튼 클릭 시 => 역 검색 창이 닫히고 선택된 값이 표시된다. (input에 hidden으로 LINE_NUM이 들어감)
			                $('.aStation_input').click(function(){
			                	$('#station_div input[name="station_name"]').val($(this).next().text());
			                	codeAddress($(this).next().text());
			                	$('#station_div input[name="station_code"]').val($(this).val());
			                	$("#station_search_result_section").empty();
			                });
						}
						if(count==0){//검색 결과가 없을 때
							cannot_search();
						}
					}
				});
			}else{ //검색어가 2자 미만 일 때
				alert("검색어를 두 글자 이상 입력하십시오.");
			}
		});
		
		// 검색 버튼을 눌렀을 때
		$('#submit_category').click(function(){
			//alert("1");
			var genre = $('#select_genre').val(); // 선택한 장르의 값
			var subway = $('#station_search_key').val(); // 선택한 지하철 역의 값
			var startDate = $('#startDate').val(); // 선택한 처음 날짜의 값
			var endDate = $('#endDate').val(); // 선택한 마지막 날짜의 값
			var longitude = $('#longitude').val();
			var latitude = $('#latitude').val();
			
			location.href='list.do?select_genre='+genre+'&station_search_key='+subway+'&startDate='+startDate+'&endDate='+endDate+'&longitude='+longitude+'&latitude='+latitude;
		});
	});//------document.ready 끝------------

	//검색이 이루어지지 않은 경우의 반응
	function cannot_search(){
		var search_exception = '<div class="not_searched">검색 결과가 없습니다.</div>';
		$('#station_search_result_section').empty().append(search_exception);
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
	
	function codeAddress(keyword) {
		var seoul = new google.maps.LatLng(37.566535, 126.977969);
		var request = {
			location : seoul,
			radius : '400',
			query : keyword
		};
	
		service = new google.maps.places.PlacesService(map);

		service.textSearch(request, function callback(results, status) {
			if (status == google.maps.GeocoderStatus.OK) {
				map.setCenter(results[0].geometry.location);
				
				var latitude = results[0].geometry.location.lat();
				var longitude = results[0].geometry.location.lng();
				
				var LatLng = new google.maps.LatLng(latitude, longitude);
				console.log("codeAddress 함수 : LatLng - " + LatLng + " /latitude - " + latitude + " /longitude - " + longitude);
				$('#longitude').val(longitude);
				$('#latitude').val(latitude);
			}
		});
	}
//------------------------------위.경도 끝------------------------------
</script>

<body>
<div id="wrapper">
	<div id="header">
		<div id="logo"><a href="main.do"><img alt="메인으로" src="images/logo.png"></a></div>
		<div id="global_menu"><a href="search.do"><img alt="검색하기" src="images/search.png"></a></div>
	</div>
	<div id="main_contents">
		<div id="popular_display">
			<div id="poster_binder">
				<div class="popular_poster"></div>
				<div class="popular_poster"></div>
				<div class="popular_poster"></div>
				<div class="popular_poster"></div>
				<div class="popular_poster"></div>
			</div>
		</div>
		<div id="select_categories">
			<form action="" method="post" id="category_search">
				<div id="select_category_txt">카테고리 선택</div>
				<div id ="categories_div">
					<div id="genre_div">
						<div class="category_name name_align">전시 장르</div>
						<select id="select_genre" onchange="startRequest()">
							<option value="">선택 안함</option>
							<option value="연극">연극</option>
							<option value="음악">음악</option>
							<option value="무용">무용</option>
							<option value="미술">미술</option>
							<option value="뮤지컬">뮤지컬</option>
							<option value="기타">기타</option>
						</select>
					</div>
					<div id="station_div">
						<div class="category_name">전철역</div>
						<input type="text" name="station_name" id="station_search_key" size="15"><!-- 선택한 역 이름이 들어오는 곳 -->
						<input type="hidden" id="latitude"><!--위도가 들어오는 곳 -->
						<input type="hidden" id="longitude"><!--경도가 들어오는 곳 -->
						<div id="station_search_btn"><img alt="역 검색" src="images/search_icon.png"></div>
						<div id="station_search_result_section"></div>
					</div>
	
					<div id="order_div">
						<div class="category_name name_align">일정 선택</div> 
						<input name="startDate" type="text" id="startDate" size="5" maxlength="8" title="시작일자"> ~ 
						<input name="endDate" type="text" id="endDate" size="5" maxlength="8" title="종료일자">
					</div>
					<input type="button" id="submit_category" value="">
				</div>
			</form>
		</div>
	</div>
	<div id="footer"></div>
		<div id="station_address">
		역명<br> <input type="text" name="station_address" id="station_search" size="20">
		<input type="button" id="station_search_btn" value="검색">
		<input type="text" id="station_location" name="station_location">
		<div id="google_map"></div>
	</div>
</div>
</body>
</html>