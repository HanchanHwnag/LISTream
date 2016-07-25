<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="w3.css">
<title>Insert title here</title>
<style type="text/css">
#favoritelist{
	
	list-style: none;
}
ul li{
	display: inline;
}

.paging{
	border: 1px solid silver;
}
.nowpaging{
	border: 1px solid silver;
}

.nowpaging a{
	background: yellow;
}

a{
	text-decoration: none;
}

.title:HOVER{
 	background: #c8c8c8;
 	cursor: pointer;
}

#user_name:HOVER{
background: #c8c8c8;
cousor:pointer;
}
</style>

<script type="text/javascript" src="../js/jquery-3.0.0.js"></script>
<script type="text/javascript">

$(function(){
		
		
		$(".playBtn").click(function(){
			parent.getCodeAndPlay($(this).attr("id"));
			
		});
		
		/* $(document).on("click",".title",function(){
			playlist_code=$(this).attr("title");
			getMusiclist(playlist_code);
		}); */
		
		$(document).on("contextmenu",".title", function(e){

			var result=confirm("삭제할까요?");
			if(!result) {
				return;
			}
			
			favorite_code=$(this).attr("id");
			cPage=$(".nowpaging").text();
			playlist_code=$(this).attr("title");
			
			location.href="deleteFavorite.do?favorite_code="+favorite_code+"&cPage="+cPage+"&playlist_code="+playlist_code;
			
			
			
		});
		
		
});//온레디

	
	
function getMusiclist(playlist_code){
		$.ajax({	
			type:"post",
			url:"getMusiclist.do",
			data:{'playlist_code':playlist_code},
			dataTypa:"xml",
			success:function(data){		
				$("#musiclistbody").remove();					
		 		var table="<tbody id='musiclistbody' align='center'>";
				$(data).find("music").each(function(i){					
								
					table+="<tr>";		
					table+="<td>"+(i+1)+"</td>";
					table+="<td>"+$(this).find("music_title").text() +"</td>";
					table+="<td>"+$(this).find("artist").text() +"</td>";			
					table+="</tr>";						
				});		
				table+="</tbody>";				
				$("#musiclisttable thead:eq(0)").after(table);			
			},
			error:function(){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	
			}			
		});//ajax
}//getMusiclist	
	
</script>
</head>
<body oncontextmenu="return false;">
	
	<div id="favoritediv" style="float: left;">
	<table id="favoritetable" class="w3-table w3-bordered w3-striped w3-small" >
		<thead align="center">
			<tr>
				<td width="50px">No.</td>
				<td width="50px">ID</td>
				<td width="300px">Playlist Name</td>
				<td>재생</td>
			</tr>
		</thead>

		<tbody align="center">
			<c:choose>
			<c:when test="${ ! empty favorite}">
			<c:forEach var="f" items="${favorite}">
				<tr>
					
					<td>${f.r_num }</td>
					<td id="user_name">${f.name}</td>
					<td class="title" id="${f.favorite_code}" title="${f.playlist_code}" onclick="getMusiclist(${f.playlist_code})">${f.playlist_title}</td>
					<td><input type="button" class="playBtn" value="▶" id="${f.playlist_code}"></td>
				</tr>
			</c:forEach>
			</c:when>
			<c:otherwise>
				<tr><td colspan="4">즐겨찾기를 등록해주세요</td></tr>
			</c:otherwise>
			</c:choose>
		</tbody>

		<tfoot align="center">
			<tr>
				<td colspan="4">
					<ul id="favoritelist">
						<c:if test="${page.beginPage <= page.pagePerBlock}">
							<li style="border: 1px solid silver">이전으로</li>
						</c:if>

						<c:if test="${page.beginPage > page.pagePerBlock}">
							
							<li>
							<a href="favorite.do?cPage=${page.beginPage - page.pagePerBlock}">활성화이전으로</a>
							</li>
							
						</c:if>
						
						<c:forEach var="k" step="1" begin="${page.beginPage}"
							end="${page.endPage}">
							<c:if test="${k == page.nowPage}">
								<li class="nowpaging" value="${k}"><a href="favorite.do?cPage=${k}">${k}</a></li>
							</c:if>

							<c:if test="${k != page.nowPage}">
								<li class="paging" value="${k}"><a href="favorite.do?cPage=${k}">${k}</a></li>
							</c:if>
						</c:forEach>
						<c:if test="${page.endPage == page.totalPage}">
								<li style="border: 1px solid silver">다음으로</li>
						</c:if>

						<c:if test="${page.endPage != page.totalPage}">
							<li><a href="favorite.do?cPage=${page.beginPage + page.pagePerBlock}">활성화다음으로</a></li>
						</c:if>
					</ul>
				</td>
			</tr>
		</tfoot>
	</table>
	</div>
	
	<div id="musiclistdiv"  style="float: right; position: fixed; width:500px; right: 5px;top:300px" >
			<table id="musiclisttable" class="w3-table w3-tiny w3-border" style="table-layout:fixed">
			<thead align="center">
					<tr>
						<th width="40px">No.</th>
						<th width="250px">Music Title</th>
						<th width="80px">Singer</th>
					</tr>
			</thead>
			</table>	
	</div>
	
	
	
	

</body>
</html>