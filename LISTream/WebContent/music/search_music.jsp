<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset=UTF-8>
<title>Insert title here</title>
<style type="text/css">
	ul {
		list-style: none;
	}
	ul {
		padding:0px;
		margin:0px;
	}
	li:HOVER{
		background-color: lightblue;
	}
	#search_div {
		border: 1px solid lightgray;
		width: 240px;
	}
</style>
<script type="text/javascript" src="../js/jquery-3.0.0.js"></script>
<script type="text/javascript">
	$(function(){
		$("#search").keyup(function(e){
			$.ajax({
				type: "post",
				url: "search_music.do",
				data: {"search" : $("#search").val()},
				dataType: "json",
				success: function(data){
					$("#search_div").empty();
					$("<ul>").attr("css", "width:200px").attr("id","search_list").appendTo($("#search_div"));
					
					for(var i=0; i<data.length; i++)
						$("<li>").attr("id", i).text(data[i]["music_title"]).appendTo("#search_list");
					
					$("li").each(function(){
						$("li").on("click", function(){
							location.href="search_music_view.do?music_title=" + $(this).text()})
						});
				},
				error : function(request,status,error){
					alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			    }
			});
		});
	});
	$(document).ready(function() {
		$("#checkall").click(function() {
			if ($("#checkall").prop("checked")) {
				$("input[name=chk]").prop("checked", true);
			} else {
				$("input[name=chk]").prop("checked", false);
			}
		})
	})
	function insert_go(f) {
		f.action="insert.do";
		f.submit();
	}
</script>
</head>
	<body>
	<form name="input_form">
		<input type="text" id="search" size="30" placeholder="music_title" value="${music_title}">
		<input id="serachBtn" type="button" value="Search"/>
		<div id="search_div"></div>
		<c:if test="${!empty list}">
			<table>
				<tr>
					<th>순번</th>
					<th>아티스트</th>
					<th>제목</th>
					<th>조회수</th>
					<th><input type="checkbox" name="all" id="checkall">전체선택</th>
				</tr>
				<c:forEach var="k" items="${list}" varStatus="status">
					<tr>
						<td>${status.count}</td>
						<td>${k.artist}</td>
						<td>${k.music_title}</td>
						<td>${k.music_hit}</td>
						<td><input type="checkbox" name="chk" /></td>
						<td><input type="button" name="play" value="듣기" /></td>
						<td><input type="button" name="put" value="담기" onclick="insert_go(this.from)"/></td>
					</tr>															
				</c:forEach>				
			</table>			
		</c:if>
		</form>
	</body>
</html>