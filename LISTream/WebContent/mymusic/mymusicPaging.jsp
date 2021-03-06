<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmf" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<!DOCTYPE>
<html>
<head>
<meta charset=UTF-8>
<title></title>


<link href="mlistcss.css" type="text/css" rel="stylesheet">
<style type="text/css">

/*수직메뉴 */
ul#plistul {
	list-style: none;
	margin: 0;
	padding: 0;
	width:100%;
	min-width:5px;
	background: #333;
}

ul#functionul{
list-style: none;
	margin: 0;
	padding: 0;
	width:100%;
	min-width:5px;
	background: #333;
}

ul#paging{
	list-style: none;
	margin: 0;
	padding: 0;
	width:100%;
	min-width:5px;
	background: #333;
}




ul#mlistul {
	list-style: none;
	margin: 0;
	padding: 0;
	width: 400px;
	background: #333;
}
font{
	margin-top: 5px;
}

li.functionli{
	display:block;
	height:30px;
 	transition: all 0.2s;
	list-style: none;
	border:1px solid #555;
	margin-top:1px;
	margin-left: 5px;
	float:left;
	background-color: #444;
}

#paging li{
	display:block;
	height:30px;
 	transition: all 0.2s;
	list-style: none;
	border:1px solid #555;
	margin-top:1px;
	margin-left: 5px;
	float:left;
	background-color: #444;
}


li.plistli {
	
	display:block;
	height:30px;
 	transition: all 0.2s;
	list-style: none;
	border:1px solid #555;
	margin-top:1px;
	margin-left: 5px;
	margin-right: 5px;
}

.functionli:HOVER  {
	/*  background: #00bd9b;  */
	 background: #666; 
	color: white;	
}

#paging li:HOVER  {
	/*  background: #00bd9b;  */
	 background: #666; 
	color: white;	
}


ul#function{
	list-style: none;
	margin: 0;
	padding: 0;
	width:100%;
	min-width:5px;
	background: #333;
}



/*플레이리스트 li  */
.plistli{
	text-align:center;
	margin-top: 8px;
	margin-bottom: 8px;
}
.plistli:HOVER {
	/*  background: #00bd9b;  */
	 background: #666; 
	color: white;
	
}
/*  */

#makeplaylist{
	text-align: center;
}

li#makeplaylist:HOVER {
	background: #a8a8a8;
	color: white;
}

li>p{
	color: white;
	size: 3px;
	margin-top: 3px;
}

div #container{
	border:1px solid red;
	background-color: #444;
	width:100%;
	height:100%;	
	
	
}
div #playlist{
		float:left;
		width:35%;		
		height:100%;
		margin: 10px;
		border:1px solid green;
		background-color: #333;
	
		
}
	

div #musiclist{
		float:left;
		width:50%;
		min-width:20px;
		height:100%;
		margin: 10px;
		border:1px solid green;
		background-color: #333;	
				
}
	
	
p#playlisttitle{
	background-color: #444;
	color: white;
	size: 6px;
	margin-top: 3px;
	
	
}

div#makeplaylistform{
	 display: none;  	
	 position: absolute; 
	width:400px;
	height:29px; 
	color:#555;
	
}	

#mlistbody{
	color: white;
}

#mlistbody td{
	width:30px;
	overflow: hidden;
	white-space: nowrap;
	text-overflow: ellipsis;
}

#musiclist1{
	color : white;
	size: 3px;
}

#dd{
	color:white;
	font-size: large;
}


#paging li{
	display: inline;
	color: white;
}


</style>
<script type="text/javascript" src="../playerTest/jquery-3.0.0.js"></script>
<script type="text/javascript">
	var playlist_code=0;
	var title="";
	var user_info_code="2";
	var cPage="1";
	var dfdf="이건테스트변수";
	
	//////페이징변수////
 	var beginpage=0;
	var endpage=0;
	var pageperblock=0;
	var nowpage=0;
	var totalpage=0;
	 

	
$(function(){
	getPlaylist(1);
	
	
	
	
	//노래목록 전체선택/해제하기
	$("#checkAll").click(function(){
		//만약 전체 선택 체크박스가 체크된상태일경우
		if($("#checkAll").prop("checked")) {
			//해당화면에 전체 checkbox들을 체크해준다
			$("input[type=checkbox]").prop("checked",true);
		
		// 전체선택 체크박스가 해제된 경우
		} else {
			//해당화면에 모든 checkbox들의 체크를해제시킨다.
			$("input[type=checkbox]").prop("checked",false);
		
		}
	});
 	
 	
 	
	//노래 삭제
	$("#deleteMusic").click(function(){
		var musiclist_codes=new Array();
		var count=0;
		$(".checkMusic:checked").each(function(){				
			musiclist_codes.push($(this).attr("id"));
			count++;
		});			
		
		if(count==0){
			alert("노래를 선택해주세요");
			return;
		}		
		
		var check=confirm("선택한 노래를 삭제할까요?");		
		if(!check){
			return;
		}	
		
		$.ajax({
			type:"post",
			url:"deleteMusiclist.do",
			data:{"musiclist_codes":musiclist_codes,"playlist_code":playlist_code,"user_info_code":user_info_code},
			dataType:"text",
			success:function(data){				
					getMusiclist(title,playlist_code);					
			},
			 error:function(request,status,error){
			      
			 }		
		});	
	});//노래삭제 click 이벤트

	
	
	
/* 	//플레이리스트 삭제이벤트
	$(document).on("contextmenu",".plistli", function(e){

		var result=confirm("삭제할까요?");
		if(!result) {
			return;
		}
		var playlist_id=$(this).attr("id");
		
		$.ajax({
			type:"post",
			url:"deletePlaylist.do",
			data : "playlist_code="+$(this).attr("id")+"&user_info_code="+2,
			dataType:"text",
			success:function(data){
				if(data>0){
					getPlaylist();
				}
			},
			error:function(data){
				alert("삭제실패");
			}
		});

	});//삭제끝
 */	 
	 
	 
	//플레이리스트 눌렀을 때 노래 목록 가져오기
	$(document).on("click",".plistli",function(){
		title=$(this).find("p").text();	
		playlist_code=$(this).attr("id");//삭제할 때 넘겨줄 code 미리 저장		
		getMusiclist(title,playlist_code);
		
	});	
	
	//플레이리스트만들기 누르면 테마가져옴
	$("#makeplaylist").click(function(){
		$.ajax({
			type:"post",
			url:"getTheme.do",
			dataType:"xml",
			success: function(data){				
			 	$("#themelist").empty();				
				var select="";
				$(data).find("theme").each(function(){						
					select+="<option value="+$(this).find("theme_code").text()+">"+$(this).find("theme_name").text();								
				});						
			 	$("#themelist").append(select);		 			
			},
			error:function(){
				alert("실패");
			}			
		});//ajax 				
	 	/* $("#makeplaylistform").slideDown(400);  */
		 $("#makeplaylistform").show(); 
		
	});//버튼
		
	$("#close").click(function(){	
		/*  $("#makeplaylistform").slideUp(400);	 */ 
		 $("#makeplaylistform").hide(); 
	});	
	
	
	
	//플레이리스트 만들기
	$("#makeplaylistbutton").click(function(){
		
		var playlist_title=$("input[name='playlist_title']").val(); 
	 	var theme_code=$("#themelist option:selected").val(); 
		
	 	$.ajax({
			type:"post",
			url:"makePlaylist.do",
			data: $("#makeform").serialize(),
			dataType:"text",
			success: function(data){
				if(data>0){
					getPlaylist(cPage);
				}
			},
			error : function(){
				alert("만들기실패");
			}
			
		});
 		
	});//플레이리스트만들기

	
});

	

	
	
//노래목록가져오는 메서드
function getMusiclist(title,playlist_code){
	
	
	$("#playlisttitle").empty();
	$("#playlisttitle").append(title);					
	$.ajax({
		type:"post",
		url:"musiclist.do",
		data : "playlist_code="+playlist_code+"&user_info_code="+user_info_code,
		dataType:"xml",
		success: function(data){				
			
			$("#mlistbody").remove();
			
		 	var table="<tbody id='mlistbody'>";
			$(data).find("music").each(function(i){					
								
				table+="<tr>";
				/* table+="<td>"+$(this).find("r_num").text() +"</td>"; */
				table+="<td>"+(i+1)+"</td>";
				table+="<td>"+$(this).find("music_title").text() +"</td>";
				table+="<td>"+$(this).find("artist").text() +"</td>";
				table+="<td><input type='checkbox' class='checkMusic' id='"+ $(this).find("musiclist_code").text()+"'/></td>"
				table+="</tr>";						
			});		
			
			table+="</tbody>";				
			$("#mlist thead:eq(0)").after(table);			
			
		},
		error:function(){
			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);

		}			
	});//ajax 		
}

//페이징정보 전역변수에 입력하기(x)
function getPageVar(){
	
	global.beginpage=parseInt($("#beginpage").text());
	global.endpage=parseInt($("#endpage").text());
	global.pageperblock=parseInt($("#pageperblock").text());
	global.nowpage=parseInt($("#nowpage").text());
	global.totalpage=parseInt($("#totalpage").text());
	
	
/* 	$(".pagevar").each(function(){
	
		var id= $(this).attr("id");
		var value=$(this).text();		
		
		switch(id){
			case "beginpage":
				beginpage=value;				
			break;
			
			case "endpage":
				endpage=value;
				break;
			
			case "pageperblock":
				pageperblock=value;
				break;
				
			case "nowpage":
				nowpage=value;
			break;
			
			case "totalpage":
				totalpage=value;
			break;
		}
	}) */
	
}//	

//플레이리스트가져오기
function getPlaylist(cPage){
	$.ajax({
		type:"post",
		url:"getPlaylist.do",
		data:"user_info_code="+user_info_code+"&cPage="+cPage,
		dataType:"xml",
		success:function(data){
			
			$(".plistli").remove();
			var li="";
			$(data).find("playlist").each(function(){
				
				li+="<li class='plistli' id='"+$(this).find("playlist_code").text()+ "'>";
				/* li+="<font color='white' size='3'>"+$(this).find("playlist_title").text()+"</font></li>"; */
				li+="<p>"+$(this).find("playlist_title").text()+"</p></li>";				
			});				
			$("#makeplaylist").after(li);			
			
			var page="";
			$(data).find("page").each(function(){
				
				page+="<p class='pagevar' id='beginpage'>"+parseInt($(this).find("beginpage").text())+"</p>";
				page+="<p class='pagevar' id='endpage'>"+parseInt($(this).find("endpage").text())+"</p>";
				page+="<p class='pagevar' id='pageperblock'>"+parseInt($(this).find("pageperblock").text())+"</p>";
				page+="<p class='pagevar' id='nowpage'>"+parseInt($(this).find("nowpage").text())+"</p>";
				page+="<p class='pagevar' id='totalpage'>"+parseInt($(this).find("totalpage").text())+"</p>";
				
			/* 	totalpage=parseInt($(this).find("totalpage").text()); */
				
			});
			
			$(".pagevar").remove();
			$("#pageContainer").append(page);
			
			getPageVar();
			
			
		},
		error:function(data){
			
		}
		
	});
}//플레이리스트 가져오기

</script>
</head>

<!--  <body oncontextmenu="return false;"> -->
 <body bgcolor="#444">
 
 	<c:set var="dfdf">
		<script>document.write(dfdf)</script>
	</c:set>
 
 
	<c:set var="beginpage">
	 	<script>document.write(beginpage)</script>
	</c:set>
 	 
	테스트:<c:out value="${pageScope.dfdf}" escapeXml="false"/>
	<%--
	 숫자 : <c:out value="${pageScope.beginpage}" escapeXml="false"/> 
	 --%>
	
	<c:set var="endpage">
		<script>document.write(endpage)</script>
	</c:set>

	
	<c:set var="pageperblock">
		<script>document.write(pageperblock)</script>
	</c:set>
	<c:set var="nowpage">
		<script>document.write(nowpage)</script>
	</c:set>
	<c:set var="totalpage">
		<script>document.write(totalpage)</script>
	</c:set>
	totalpage : <c:out value="${pageScope.totalpage}" escapeXml="false"/> 
	 




	<!--플레이리스트추가하기 DVI  -->
	<div id="makeplaylistform">
		<form id="makeform" style="float:left;">
			<input type="text" name="playlist_title">
			<select name="theme_code" id="themelist">
			</select>
			<input type="hidden" name="user_info_code" value="2">
		</form>		
		<input style="float:left;" type="button" value="만들기" id="makeplaylistbutton"/>			
		<input style="float:left;" type="button" value="창닫기" id="close"> 	
	</div>
	<!--플레이리스트추가하기 DVI  -->
	
	<div id="container">
		<!-- 플레이리스트목록DVI -->
		<div id="playlist">
			<ul id="plistul">
				<li id="makeplaylist"><font color="#c457f4">+새 플레이리스트</font></li>			
			</ul>
			
<%-- 
			<ul id="paging">		
			
				<c:if test="${pageScope.beginpage <= pageScope.pageperblock}">
					<li>이전으로<li>
				</c:if>

				<c:if test="${pageScope.beginpage > pageScope.pageperblock}">					
					<li class="prepage" onclick="getPlaylist(${pageScope.beginpage - page.pageperblock})">이전으로</li>	
				</c:if>


				<c:forEach var="k" step="1" begin="${pageScope.beginpage}" end="${pageScope.endpage}">
					<c:if test="${k == pageScope.nowpage}">
						<li class="paging nowPage" value="${k}">${k}</li>
					</c:if>

					<c:if test="${k != pageScope.nowpage}">
						<li class="paging" value="${k}">${k}</li>
					</c:if>
				</c:forEach>


				<c:if test="${pageScope.endpage == pageScope.totalpage}">
					<li>다음으로<li>
				</c:if>

				<c:if test="${pageScope.endpage != pageScope.totalpage}">					
					<li class="nextpage" onclick="getPlaylist(${pageScope.beginpage + pageScope.pageperblock})">다음으로</li>
				</c:if>
			</ul>
 --%>

		</div>
		<!-- 플레이리스트목록DVI -->
		
		
		
		
		
		
		
		
		<!--노래목록 DIV  -->
		<div id="musiclist" >
			<p id="dd">노래목록</p>
			<p id="playlisttitle">플레이리스트제목  </p> 	
			
			<p>		
			<ul id="functionul">
				<li class="functionli" id="deleteMusic"><p>ⓧ 노래삭제</p></li>
				<li class="functionli" id="playMusic"><p>▶재생</p></li>
			</ul>		
		<p >&nbsp;</p>			
	 	
				<table id="mlist" border="1">
					<thead style="color:white ">
						<tr>
							<th width="40px">번호</th>
							<th width="250px">제목</th>
							<th width="80px">가수</th>
							<th width="100px">전체선택<input type="checkbox" id="checkAll"/></th>
						</tr>
					</thead>	

			</table> 
		</div>
		<!--노래목록 DIV  -->		
	</div>
	
	<div id="pageContainer" style="display: none; position: fixed; width:1px; height:1px;" >
		페이지변수여
	</div>	
</body>
</html>