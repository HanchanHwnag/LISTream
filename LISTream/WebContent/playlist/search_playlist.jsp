<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset=UTF-8>
<title>Insert title here</title>
<link href="http://www.w3schools.com/lib/w3.css" type="text/css" rel="stylesheet">
<style type="text/css">
ul {
	list-style: none;
	padding: 0px;
	margin: 0px;
}

li.paging {
	display: inline;
	padding: 10px;
}

li:HOVER {
	background-color: lightblue;
}

#search_div {
	border: 1px solid lightgray;
	border-top: none;
	width: 420px;
}

table.music_list, table.music_table {
	width: 580px;
	word-break: break-all;
	height: auto;
}

table.music_list th, table.music_table th {
	min-width: 50px;
}

td.playlist_detail:hover {
	cursor: pointer;
	background-color: lightblue;
}

ul#theme {
	padding: 10px;
	width: 580px;
	background-color: #333333;
}

li.theme {
	color: white;
	display: inline;
	padding: 10px;
}

li.theme:HOVER {
	background-color: #666666;
	color: white;
}

li.active {
	background-color: #666666;
}

.selected {
	background-color: lightblue;
}

.nowPage {
	background-color: lightblue;
	color: white;
}

a {
	text-decoration: none;
}

#fixedbar {
	width: 300px;
	padding: 10px;
	background-color: #666666;
	position: absolute;
	visibility: hidden;
	top: -20px;
	left: 10px;
	bottom: 0px;
}

#sidebar {
	position: relative;
	left: 650px;
}

p.song {
	width: 300px;
	overflow: hidden;
	white-space: nowrap;
	text-overflow: ellipsis;
}
</style>
<style>
#menu {
	width: 330px;
	height: 100%;
	position: fixed;
	top: 0px;
	right: -332px;
	z-index: 10;
	border: 1px solid #c9c9c9;
	background-color: white;
	text-align: center;
	transition: All 0.2s ease;
	-webkit-transition: All 0.2s ease;
	-moz-transition: All 0.2s ease;
	-o-transition: All 0.2s ease;
}

#menu.open {
	right: 0px;
}

.close {
	width: 50px;
	height: 50px;
	position: absolute;
	right: 0px;
	top: 0px;
	z-index: 1;
	background-image:
		url("http://s1.daumcdn.net/cfs.tistory/custom/blog/204/2048858/skin/images/close.png");
	background-size: 50%;
	background-repeat: no-repeat;
	background-position: center;
	cursor: pointer;
}
</style>
<script type="text/javascript" src="../js/jquery-3.0.0.js"></script>
<script type="text/javascript">
	$(function(){
		$.ajax({
			url : "theme.do",
			type : "post",
			dataType : "json",
			success : function(data){
				var i;
				for(i=0; i<data.length; i++){
					if("${theme}" == data[i]["theme_code"])
						$("<li>").attr("class","theme active").val(data[i]["theme_code"]).text(data[i]["theme_name"]).appendTo($("#theme"));
					else
						$("<li>").attr("class","theme").val(data[i]["theme_code"]).text(data[i]["theme_name"]).appendTo($("#theme"));
				}
				
				$("li.theme").each(function(){
					$(this).click(function(){
						location.href = "searchPlayListView.do?theme=" + $(this).val();
					});
				});
				
				// 페이징
	     		$("li.paging").each(function(){
					$(this).children("a").attr("href","searchPlayListView.do?cPage=" + 
					$(this).val() + "&theme=" + $(".active").val());
				});
			},
			error : function(request,status,error){
				
		    }
		});
		
		// checkbox 모두 체크
		var idx=0;
		 $("#checkall").click(function() {
			 idx++;
	        if (idx%2 == 1) {
	           $(".chk").prop("checked", true);
	        } else {
	           $(".chk").prop("checked", false);
	        }
	     });
	     
	     $("#put").on("click", function(){
	     	var chk = false;
			var arr_checked = new Array();
			$("input.chk").each(function(){
				if($(this).is(":checked")){
					chk = true;
					arr_checked.push($(this).val());
				}
			});

			if(!chk){
				alert("음악을 선택해주세요");
				return;
			}
			
			$.ajax({
				url : "favorite_insert.do",
				type : "post",
				data : {"arr_checked" : arr_checked},
				dataType : "text",
				success : function(data){
					alert("즐겨찾기에 추가되었습니다.");
				},
				error : function(request,status,error){
					
			    }
			});
	     });
	     
	     var id;
	     // 상세보기(플레이리스트 내용) // 댓글 가져오기
	     $(".playlist_detail").each(function(){
	    	$(this).on("click", function(){
	    		$.ajax({
	    			url : "playlist_detail.do",
	    			type : "post",
	    			data : {"playlist_code" : $(this).attr("title")},
	    			dataType : "json",
	    			success : function(data){
	    				$("div#music_detail").empty();
	    				
	    				$("<table>").attr("class", "music_table").appendTo($("div#music_detail"));
	    				$("<tr>").attr("id", "catalog").appendTo($("table.music_table"));
	    				$("<th>").text("순위").appendTo($("tr#catalog"));
    					$("<th>").text("아티스트").appendTo($("tr#catalog"));
    					$("<th>").text("제목").appendTo($("tr#catalog"));
    					$("<th>").text("조회수").appendTo($("tr#catalog"));
	    				
	    				for(var i=0; i<data.length; i++){
	    					$("<tr>").attr("id", i).appendTo($("table.music_table"));
	    					$("<td>").text(data[i]["r_num"]).appendTo($("tr#" + i));
	    					$("<td>").text(data[i]["artist"]).appendTo($("tr#" + i));
	    					$("<td>").text(data[i]["music_title"]).appendTo($("tr#" + i));
	    					$("<td>").text(data[i]["music_hit"]).appendTo($("tr#" + i));
	    				}
	    			},
	    			error : function(request,status,error){
						
				    }
	    		});
	    		
	    		$("#menu").addClass("open");
				id = $(this).attr("title");
					
				$.ajax({
					url : "reply.do",
					type : "post",
					dataType : "json",
					data : {"playlist_code" : $(this).attr("title")},
					success : function(data){
						reply(data);
					}, 
					error : function(request,status,error){
						
					}
				});
	    	});
	     });
			
		// 댓글 창 닫기
		$(".close").click(function() {
			 $("#menu").removeClass("open");
		});
			
		// 댓글 쓰기
		$("#write").click(function(){
			$.ajax({
				url : "reply_write.do",
				type : "post",
				dataType : "json",
				data : {"playlist_code" : id, "pwd" : $("#pwd").val(), 
						"content" : $("#content").val()},
				success : function(data){
					$("#content").val("");
					reply(data);
				}, 
				error : function(request,status,error){
					
				}
			});
		});
			
		// 댓글 몸체
		function reply(data){
			$("#reply_content").empty();
			for(var i=0; i<data.length; i++){
				$("<tr>").attr("id", i + "reply").appendTo($("#reply_content"));					
				$("<td>").text(data[i]["id"]).appendTo($("#" + i + "reply"));
				$("<td>").text(data[i]["content"]).appendTo($("#" + i + "reply"));
				if(data[i]["id"] == "${login_vo.id}"){
					var temp_data = $("<td>");
					temp_data.appendTo($("#" + i + "reply"));
					$("<input>").attr("class", "del").attr("name", data[i]["reply_code"]).attr("type", "button").val("삭제").appendTo(temp_data);
				}
					
				$("input.del").each(function(){
					$(this).on("click", function(){
						$.ajax({
							url : "reply_delete.do",
							type : "post",
							dataType : "json",
							data : {"reply_code" : $(this).attr("name"),
									"playlist_code" : id },
							success : function(data){
								reply(data);
							},
							error : function(request,status,error){
								
						    }
						});
					});
				});
			}
		}
	});
</script>
</head>
<body>
	<ul id="theme"></ul>
	<div id="sidebar">
		<div id="fixedbar"></div>
	</div>
	<c:if test="${!empty list}">
		<table class="music_list" style="text-align: center">
			<tr>
				<th>순번</th>
				<th>제목</th>
				<th>날짜</th>
				<th>조회수</th>
				<th><input type="button" id="checkall" value="all"></th>
				<th><input type="button" value="put" id="put"></th>
			</tr>
			<c:forEach var="k" items="${list}">
				<tr>
					<td>${k.r_num}</td>
					<td class="playlist_detail" title="${k.playlist_code}">${k.playlist_title}</td>
					<td>${k.regdate.substring(0,10)}</td>
					<td>${k.hit}</td>
					<td><input type="checkbox" class="chk"
						value="${k.playlist_code}"></td>
					<td></td>
				</tr>
			</c:forEach>
			<tr>
				<td colspan="4">
					<ul>
						<c:if test="${page.beginPage <= page.pagePerBlock}">
							<input type="button" value="이전으로" disabled="disabled" />
						</c:if>
						<c:if test="${page.beginPage > page.pagePerBlock}">
							<input type="button" value="이전으로"
								onclick="sendPage(${page.beginPage - page.pagePerBlock})" />
						</c:if>

						<c:forEach var="k" step="1" begin="${page.beginPage}"
							end="${page.endPage}">
							<c:if test="${k == page.nowPage}">
								<li class="paging nowPage" value="${k}"><a>${k}</a></li>
							</c:if>
							<c:if test="${k != page.nowPage}">
								<li class="paging" value="${k}"><a>${k}</a></li>
							</c:if>
						</c:forEach>

						<c:if test="${page.endPage == page.totalPage}">
							<input type="button" value="다음으로" disabled="disabled" />
						</c:if>
						<c:if test="${page.endPage != page.totalPage}">
							<input type="button" value="다음으로"
								onclick="sendPage(${page.beginPage + page.pagePerBlock})" />
						</c:if>
					</ul>
				</td>
			</tr>
		</table>
	</c:if>
	<div id="music_detail"></div>
	<div id="menu">
		<h1>댓글</h1>
		<div class="close"></div>
		<div id="ans_write">
			<table>
				<tr>
					<th>Content</th>
					<td><textarea style="margin-left: 10px" id="content"
							placeholder="Content" style="width:80%" rows="3"></textarea></td>
				</tr>
				<tr>
					<td colspan="2"><input id="write" type="button" value="Write"
						style="width: 100%"></td>
				</tr>
			</table>
		</div>
		<div style="overflow:auto; max-height:70%">
			<table class="w3-table w3-tiny w3-striped w3-bordered w3-border">
				<thead>
					<tr style="width: 100%">
						<th style="width: 30%">작성자</th>
						<th style="width: 60%">내용</th>
						<th></th>
					</tr>
				</thead>
				<tbody id="reply_content">
					
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>