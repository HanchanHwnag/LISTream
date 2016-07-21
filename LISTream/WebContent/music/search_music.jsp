<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset=UTF-8>
<title>Insert title here</title>
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

table {
	width: 580px;
	word-break: break-all;
	height: auto;
}

th {
	min-width: 50px;
}

#genre {
	padding: 10px;
	width: 580px;
	background-color: #333333;
}

.genre_list {
	color: white;
	display: inline;
	padding: 10px;
}

.genre_list:HOVER {
	background-color: #666666;
	color: white;
}

.active {
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
	width:300px;
	padding:10px;
	background-color: #666666;
	position: absolute;
	visibility: hidden;
	top: -20px;
	left: 10px;
	bottom: 0px;
}

#sidebar {
	position: relative;
	left:  650px;
}

p.song {
	width: 300px;
	overflow: hidden;
	white-space: nowrap;
	text-overflow: ellipsis;
}
</style>
<script type="text/javascript" src="../js/jquery-3.0.0.js"></script>
<script type="text/javascript">
	$(function(){
		// 장르 가져오기
		$.ajax({
			url: "genre.do",
			type: "post",
			dataType: "text",
			success: function(data){
				var data = data.split("/");
				var genre = "${genre}";
				if(genre != null && genre.trim() != "")
					genre = "${genre}";
				else
					genre = -1;	
					
				for(var i=0; i<data.length; i++){
					var t_date = data[i].split(",");
					if(genre == -1){
						if(t_date[0] == 0)
							$("<li>").attr("class", "active genre_list").attr("value", t_date[0]).text(t_date[1]).appendTo($("#genre"));
						else
							$("<li>").attr("class", "genre_list").attr("value", t_date[0]).text(t_date[1]).appendTo($("#genre"));
					} else {
						genre = genre.trim();
						t_date[0] = t_date[0].trim();
						if(t_date[0] == genre)
							$("<li>").attr("class", "active genre_list").attr("value", t_date[0]).text(t_date[1]).appendTo($("#genre"));
						else
							$("<li>").attr("class", "genre_list").attr("value", t_date[0]).text(t_date[1]).appendTo($("#genre"));
					}
				}
					
				$("li.genre_list").each(function(){
					$(this).on("click", function(){
						location.href = "search_music_view.do?genre=" + $(this).val() + "&type=" + $("#type").val() + "&search_text=" + $("#search").text();
					});
				});
				
				$("li.paging").each(function(){
					$(this).children("a").attr("href","search_music_view.do?cPage=" + 
							$(this).val() + "&search_text=" + $("#search").text() + "&type=" + 
							$("#type").val() + "&genre=" + $(".active").val());
				});
			},
			contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
			error: function(request,status,error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
		
		// 연관 검색어
		var which;
		$("#search").keyup(function(e){
			$.ajax({
				type: "post",
				url: "search_music.do",
				data: {"search" : $("#search").val(), "field" : $("#type").val(), "genre" : $(".active").val()},
				dataType: "json",
				success: function(data){
					$("#search_div").empty();

					$("<ul>").attr("css", "width:200px").attr("id","search_list").appendTo($("#search_div"));
					
					for(var i=0; i<data.length; i++)
						$("<li>").attr("class","search_text").attr("id", i).text(data[i]["search_text"]).appendTo("#search_list");
					
					$("li.search_text").each(function(){
						$(this).on("click", function(){
							location.href="search_music_view.do?search_text=" + $(this).text() + "&type=" + $("#type").val() + "&genre=" + $(".active").val();
						})
					});
					
					if(e.which == 40){
						which++;
						if(which >= $("#search_list").children().length)
							which = 0;
						$("#search_list").children().eq(which).attr("class","selected");
					} else if(e.which == 38) {
						which--;
						if(which < 0)
							which = 0;
						$("#search_list").children().eq(which).attr("class","selected");
					} else if(e.which == 13){
						$("#search_list").children().eq(which).attr("class","selected");
						$(".selected").trigger("click");
					} else {
						which = -1;
					}
				},
				error : function(request,status,error){
					alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			    }
			});
		});
		
		// 플레이리스트
		$.ajax({
			type: "post",
			url : "playlist.do",
			dataType : "json",
			success : function(data){
				var i;
				for(i=0; i<data.length; i++)
					$("<option>").attr("class","playlist_item").attr("value", data[i]["playlist_code"]).text(data[i]["playlist_title"]).appendTo($("#playlist"));
				
				$(document).ready(function(){
					$.ajax({
						type: "post",
						url : "playlist_music.do",
						dataType : "json",
						data : {"playlist_code" : "${playlist_code}"},
						success : function(data){
							playlist(data);
						},
						error : function(request,status,error){
							alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
					    }
					});
				});
				$("#playlist").on("click", function(){
					$.ajax({
						type: "post",
						url : "playlist_music.do",
						dataType : "json",
						data : {"playlist_code" : $(this).val()},
						success : function(data){
							playlist(data);
						},
						error : function(request,status,error){
							alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
					    }
					});
				});
			}, 
			error : function(request,status,error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		    }
		});
		
		function playlist(data){
			$("#fixedbar").css("visibility", "visible");
			$("#fixedbar").empty();
			
			$("<h3>").text("SongList").appendTo($("#fixedbar"));
			$("<hr>").appendTo($("#fixedbar"));
			
			for(i=0; i<data.length; i++)
				$("<p>").attr("class", "song").text(data[i]["music_title"]).appendTo($("#fixedbar"));
		}
		
		var idx = 0;
		// checkbox 모두 체크
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
				url : "music_insert.do",
				type : "post",
				data : {"arr_checked" : arr_checked, "playlist_code" : $("#playlist option:selected").val(),
						"search_text" : $("#search").text(), "type" : $("#type").val(), "genre" : $(".active").val()},
				dataType : "json",
				success : function(data){
					location.href="search_music_view.do?search_text=" + data[0]["search_text"]
							+ "&type=" + data[0]["type"] + "&genre=" + data[0]["genre"] + "&playlist_code=" + data[0]["playlist_code"];
				},
				error : function(request,status,error){
					alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			    }
			});
		});
	});
</script>
</head>
<body>
	<ul id="genre"></ul>
	<input type="text" id="search" size="55" placeholder="search_text"
		value="${search_text}" autocomplete="off">
	<select id="type">
		<c:choose>
			<c:when test="${type eq 'singer'}">
				<option value="singer" selected="selected">가수별</option>
				<option value="title">제목별</option>
			</c:when>
			<c:when test="${type eq 'title'}">
				<option value="singer">가수별</option>
				<option value="title" selected="selected">제목별</option>
			</c:when>
			<c:otherwise>
				<option value="artist" selected="selected">가수별</option>
				<option value="music_title">제목별</option>
			</c:otherwise>
		</c:choose>
	</select>
	<select id="playlist"></select>
	<div id="sidebar">
		<div id="fixedbar"></div>
	</div>
	<div id="search_div"></div>
	<c:if test="${!empty list}">
		<table style="text-align: center">
			<tr>
				<th>순번</th>
				<th>아티스트</th>
				<th>제목</th>
				<th>조회수</th>
				<th><input type="button" id="checkall" value="all"></th>
				<th><input type="button" value="put" id="put"></th>
			</tr>
			<c:forEach var="k" items="${list}">
				<tr>
					<td>${k.r_num}</td>
					<td>${k.artist}</td>
					<td>${k.music_title}</td>
					<td>${k.music_hit}</td>
					<td><input type="checkbox" class="chk" value="${k.music_code}"></td>
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

						<c:forEach var="k" step="1" begin="${page.beginPage}" end="${page.endPage}">
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
</body>
</html>