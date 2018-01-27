<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>전시 상세 페이지</title>
<link rel="stylesheet" type="text/css" href="${initParam.root }css/sub.css">
<script src="http://code.jquery.com/jquery-1.7.2.min.js"></script>
<script src="http://code.jquery.com/jquery-migrate-1.1.0.js"></script>
<script type="text/javascript">

	$(document).ready(function(){
		view();
	});

	function open_window(seq){
  		window.open("place.do?seq="+seq, "전시/공연장 정보", 'left=150, top=100, width=800, height=600, toolbar=no, menubar=no, status=no, scrollbars=no, location=no, resizable=yes');
	}
	
	function view(){
		var seq = <%= request.getParameter("seq") %>;
		$.ajax({
	         type:"GET",
	         url:"toView.do", 
	         dataType: "xml",
	         data: {seq:seq},
	         success: function(data){
	        	 console.log(data);
	        	 var xmlData = $(data).find("response").find("msgBody").find("perforInfo");
	        	 var listLength = xmlData.length;
	        	 
	        	 var title = '';
	        	 var poster = '';
	        	 var detail = '';
	        	 var content = '';
	        	 for(var i=0; i<listLength; i++){
	        		title += $(data).eq(i).find('title').text();
	        		content += '<b>'+"장소 | "+'</b>'+$(data).eq(i).find('place').text()+" ("+$(data).eq(i).find('placeAddr').text()+")"+'<br><br>';
	        		content += '<b>'+"기간 | "+'</b>'+$(data).eq(i).find('startDate').text()+" ~ "+$(data).eq(i).find('endDate').text()+'<br><br>';
	        		content += '<b>'+"기본가 | "+'</b>'+$(data).eq(i).find('price').text()+'<br><br>';
	        		content += '<b>'+"문의처 | "+'</b>'+$(data).eq(i).find('phone').text()+'<br>';
	        		content += '<a href="javascript:open_window('+xmlData.eq(i).find('seq').text()+')">공연장 정보 보기</a>';
	        		poster += '<img src="'+$(data).eq(i).find('imgUrl').text()+'" alt="poster" width="167px" height="245px">';
	        		detail += $(data).eq(i).find('contents1').text()+'<br><br><br>'+$(data).eq(i).find('contents2').text();
	        		
	        		$('#hidden_seq').val(seq);
	        		$('#hidden_thumbnail').val($(data).eq(i).find('imgUrl').text());
	        		$('#hidden_title').val($(data).eq(i).find('title').text());
	        		$('#hidden_endDate').val($(data).eq(i).find('endDate').text());
	        	 }
	        	 $('#display_view_info_title').empty().append(title);
	        	 $('#display_view_poster').empty().append(poster);
	        	 $('#display_view_info_content').empty().append(content);
	        	 $('#display_view_info_detail').empty().append(detail);
	        	 
	        	 hit();
	       }
	   });
	}
	
	function hit(){
		if($('#user').val()=='stranger'){
			// 1분 안에 해당 페이지에 방문한 기록이 없는 사용자일 경우에만 조회수 +1
			$.ajax({
		         type:"POST",
		         url:"update_hit.do",
		         data:$('#userInfo').serialize(),
		         success: function(data){}
		   });
		}
	}
</script>
</head>
<body>
<form action="" id="userInfo" style="display:none;">
	<input type="hidden" id="user" value="${user }">
	<input type="hidden" id="hidden_seq" name="seq" value="">
	<input type="hidden" id="hidden_thumbnail" name="thumbnail" value="">
	<input type="hidden" id="hidden_title" name="title" value="">
	<input type="hidden" id="hidden_endDate" name="endDate" value="">
</form>
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
			<%-- 전시 상세 내용 보기 --%>
			<div id="display_view_content">
				<div id="display_view_title"></div>
				<%-- 선택한 해당 전시의 포스터 --%>
				<div id="display_view_poster"></div>
				<%-- 선택한 해당 전시에 대한 상세 정보 --%>
				<div id="display_view_info">
					<div id="display_view_info_title"></div>
					<div id="display_view_info_content"></div>
				</div>
				<div id="display_view_info_detail"></div>
			</div>
			
			<%-- 댓글 --%>
			<div id="reply_content">
				<%-- 댓글을 작성하는 공간 --%>
				<div id="reply_write">임시 - 댓글 작성 공간</div>
				<%-- 작성한 댓글을 보여주는 공간 --%>
				<div id="reply_view">임시 - 댓글 View 공간</div>
			</div>
		</div>
		<div id="footer"></div>
	</div>
</body>
</html>