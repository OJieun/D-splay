<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<style>
*{margin:0px;}

#wrapper {width:100%; height: auto; float: left;}
#header{width:100%; height:102px;  background: url("images/header.png"); float: left;}
#logo{width: 168px; height: 46px; float: left; margin-left: 33px; margin-top: 30px;}
#global_menu{width:58px; height: 16px; float:left; margin-left: 78%; margin-right: 34px; margin-top: 43px;}
#footer{width:100%; height: 88px; background: url("images/footer.png"); float: left;}

#search_content{width : 100%; height:auto; float: left;}
#search_bar_area{margin:0 auto; width : 100%; height : 100px; text-align: center; background-color : #5E5E5E; padding:30px 0 0 0;}
	#search_input_area{height : 70px; line-height : 70px; }
		#search_type{width : 80px; height: 40px; margin-right: 10px; font-size:10pt; font-weight: bold; font-family: '맑은 고딕';}
			#search_type option{height : 20px; line-height : 20px;}
		#search_input{width: 500px; height: 38px; border : 1px solid #dadada; font-size: 16pt; font-weight:bold;  font-family: '맑은 고딕'; margin : 0 5px 0 5px; vertical-align:-5px;}
			#searched_stations{position: absolute; float: left; width: 500px; height: auto; background: white; border : 1px solid #8C8C8C;}
			.aStation, .stationNotExist{width : 100%; float:left; height : 25px; line-height:25px; cursor: pointer;}
			.station_name{font-weight: bold; font-size: 11pt; height: 25px;  line-height:25px; float: left; margin-left : 10px;}
			.line_num{color : #8C8C8C; font-size: 9pt; height: 25px; line-height:25px; float: left; margin-left : 10px;}
		#search_name_btn, #search_subway_btn{width:80px; height: 40px; background: url("images/main_search.png") repeat scroll 0 0 rgba(0, 0, 0, 0); margin-left : 10px;}
#search_result_area{width:100%; height : 100%;}
	#progressCover{position: absolute; width: 100%; height: 100%;  background-color:rgba(0,0,0,0.5); z-index:10;}
		#progressCover img{margin: 50px 0 0 48% ;}
	.not_searched, .stationNotExist{width : 100%; height : 100px; font-weight: bold; font-family: '맑은 고딕'; font-size : 12pt; color:#353535; text-align: center; line-height: 100px;}
	#result_container{float: left; width : 80%; height: auto; margin : 15px 20px;}
		.aResult{float: left; width: 250px; height : 400px; font-family: '맑은 고딕'; border : 1px solid #38ADC1; text-align: center; margin : 5px 5px; cursor: pointer;}
		.aPoster{width:180px; height:231px; margin : 10px 0;}
		.aTitle{font-size : 12pt; height : 50px; font-weight: bold; width: 240px; overflow: hidden; text-overflow:ellipsis; margin-left: 5px; line-height: 22px; color: #474747;}
		.fromTo, .aPlace, .aRealm{font-size : 10pt; color:#353535; height: 15px; line-height: 15px; margin-top : 10px; width: 200px; margin-left: 25px; color: #747474; text-align: left;}

#station_address{display:none;}

</style>
<script src="http://code.jquery.com/jquery-1.7.2.min.js"></script>
<script src="http://maps.google.com/maps/api/js?sensor=false&libraries=places"></script>
<script type="text/javascript">
$(document).ready(function(){
	initializeGoogleMap();
	checkLocationHash();
	
	$('#search_result_area').on('mouseover', '.aResult', function(){
		$(this).css('border', '1px solid #FF9436');
	}).on('mouseout', '.aResult',function(){
		$(this).css('border', '1px solid #38ADC1');
	}).on('click', '.aResult', function(){
		//ajax 뒤로가기 문제 해결 - hash에 저장
		var search_type = $('#search_type').val();
		var search_key = $("#search_input").val();
		str_hash=search_type+"^"+search_key;
		document.location.hash = "#" + str_hash;
	
		location.href='view.do?seq='+$(this).attr('id');
	});
	
	//검색유형 선택
	$('#search_type').change(function(){
		$('#searched_stations').remove();
		var type=$("#search_type option:selected").val();
		if(type=='subway'){
			$('#search_name_btn').hide();
			$('#search_subway_btn').show();
			//역 검색
			$('#search_subway_btn').click(function(){
				var keyword = $('#search_input').val();
				if(keyword.length>1){
					$.ajax({
						type:"GET",
						url:"data/subway_name_search.json",
						dataType: "json",
						success: function(json){
							searched_stations(json, keyword);
						}
					});
				}else{alert("검색어를 두 글자 이상 입력하십시오.");}
			});
		}else{//type=='name'
			$('#search_name_btn').show();
			$('#search_subway_btn').hide();
		}		
	});
	
	//전시 명으로 검색할 때
	$('#search_name_btn').click(function(){
		var keyword = $('#search_input').val();
		if(keyword.length>0){
			loading();		
			ajax_search_name(keyword);
		}
	});
	
	//전철역 목록 클릭하는 경우 
	$('body').on('click', '.aStation', function(e){ 
		var text = $(this).find('.station_name').text();
		$('#searched_stations').remove();
		$('#search_input').val(text);
		$('#station_search').val(text);
		
		loading();
		codeAddress($('#station_search').val());
	}).on('mouseover', '.aStation', function(e){
		$(this).css('background', '#EAEAEA'); 
	}).on('mouseout', '.aStation', function(e){
		$(this).css('background', 'white');
	});
});//--------document.ready 끝

	function loading(){
		$('#search_result_area').empty();
		$('#search_result_area').append('<div id="progressCover"><img src="images/ajax-loader.gif"></div>');
	}

  //뒤로가기 해서 접근했을 때 hash 처리하는 함수
	function checkLocationHash(){
		if(document.location.hash){
	     //hash 가 있다면 ^ 를 구분자로 하나씩 string을 추출하여 각각 페이지정보를 가져옴
			var str_hash = document.location.hash;
			str_hash = str_hash.replace("#","");
			var arr_searchInfo=str_hash.split("^");
			var hashed_search_type=arr_searchInfo[0];
			var hashed_search_key=arr_searchInfo[1];

			if(hashed_search_key.length>1){//검색어가 있었던 경우
				loading();
				if(hashed_search_type=='name'){ //공연명으로 검색했던 경우
					$('#search_subway_btn').hide(); $('#search_name_btn').show();
					ajax_search_name(hashed_search_key);
				}else{//전철역으로 검색했던 경우
					$('#search_name_btn').hide(); $('#search_subway_btn').show(); 
					codeAddress(hashed_search_key);
				}
			}
		}else{//hash가 없으면 뒤로가기 한 것이 아니므로 default값- 제목으로 검색.
			$('#search_subway_btn').hide();
		}
	}

	//전시 명으로 검색하는 함수
	function ajax_search_name(keyword){
		$.ajax({
			type:"GET",
			url:"search_name.do",
			dataType: "xml",
			data:{keyword:keyword},
			success: function(xml){
				var $xmlData = $(xml).find("response").find("msgBody").find("perforList");
                var listLength = $xmlData.length;
				alignResult($xmlData, listLength);
				//로딩 이미지 제거
				$('#progressCover').remove();
			},
		});
	}
	
	//전철역의 위도경도를 받아 ajax로 검색하는 함수
	function search_by_location(latitude, longitude){
		$.ajax({
			type:"GET",
			url:"search_by_location.do",
			dataType: "xml",
			data:{latitude:latitude, longitude:longitude},
			success: function(xml){
				var $xmlData = $(xml).find("response").find("msgBody").find("perforList");
                var listLength = $xmlData.length;
				alignResult($xmlData, listLength);
			}
		});
	}

	//받아온 전시 정보 뽑는 함수
	function alignResult($xmlData, listLength){
		if(listLength>0){//검색 결과가 있을 때
			var box = '<div id="result_container">';
			for(var i=0; i<listLength; i++){
				box+='<div class="aResult" id="'+$xmlData.eq(i).find('seq').text()+'">';
				box+='<img src="'+$xmlData.eq(i).find('thumbnail').text()+'" alt="poster" class="aPoster">';
				box+='<div class="aTitle">'+$xmlData.eq(i).find('title').text()+'</div>';
				box+='<div class="aRealm"> 장르 | '+$xmlData.eq(i).find('realmName').text()+'</div>';
				box+='<div class="fromTo"> 기간 | '+$xmlData.eq(i).find('startDate').text()+' ~ '+$xmlData.eq(i).find('endDate').text()+'</div>';
				box+='<div class="aPlace"> 장소 | '+$xmlData.eq(i).find('place').text()+'</div>'; 
				box+='</div>';
			}
			box += '</div>';
			$('#search_result_area').empty().append(box);
		}else{
			$('#search_result_area').empty().append('<div class="not_searched">검색 결과가 없습니다.</div>');
		}
	}
	

	//검색된 전철역 목록 뽑는 함수
	function searched_stations(json, keyword){
		var position = $('#search_input').position();
		var left = position.left;
		var top = position.top;
		
		var station_list = json.DATA;
		var contentStrHeader='<div id="searched_stations" style="top:'+(top+43)+'px;left:'+(left+6)+'px;">';
		var contentStr = '';
		var listLen = station_list.length;
		
		if(listLen>0){//검색 결과가 있을 때 실행
            for(var i=0; i<listLen; i++){
				if(station_list[i].STATION_NM.match(keyword)){
					contentStr += '<div class="aStation" id="station'+i+'">';
					contentStr += '<span class="station_name">'+station_list[i].STATION_NM+'역</span><span class="line_num">'+station_list[i].LINE_NUM+'호선</span></div>';
				}                   
            }
		}

		if(contentStr.length>0){//검색한 역이 존재할 때
            contentStr = contentStrHeader+contentStr+'</div>';
            $("#searched_stations").remove();
            $("body").append(contentStr);
		}else{
			contentStr = '<div class="stationNotExist">해당하는 역이 없습니다.</div></div>';
			$('body').append(contentStrHeader+contentStr);
		}
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
	
	function codeAddress(address) {
//		var address = document.getElementById("station_search").value;
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

</script>
<body>
<div id="wrapper">
	<div id="header">
		<div id="logo"><a href="main.do"><img alt="메인으로" src="images/logo.png"></a></div>
		<div id="global_menu"><a href="search.do"><img alt="검색하기" src="images/search.png"></a></div>
	</div>
	<div id="search_content">
		<div id="search_bar_area">
			<form action="" method="post" onsubmit="return false">
				<div id="search_input_area">
					<select name="search_type" id="search_type">
						<option value="name" selected>제목</option>
						<option value="subway">전철 역</option>
					</select>
					<input id="search_input" type="text" name="search_key">
					<input id="search_name_btn" type="button">
					<input id="search_subway_btn" type="button">
				</div>
			</form>
		</div>
		<div id="search_result_area">
			<div class="not_searched">검색어를 입력하십시오.</div>
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