<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE>
<html>
<head>
<meta charset=UTF-8>
<link rel="stylesheet" href="w3.css">
<title></title>
 
 
<script type="text/javascript" src="../js/jquery-3.0.0.js"></script>
<script type="text/javascript">
	var playlist_code=0;
	var title="";
	var user_info_code=${login_vo.user_info_code};
	var dfdf="이건테스트변수";
	
 
	
$(function(){
	getPlaylist();
	
	
	
	
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
	
	//플레이리스트 재생 버튼 클릭
	$("#playMusic").click(function(){
		parent.getCodeAndPlay(playlist_code);
	});
 
	
	
	
 	//플레이리스트 삭제이벤트
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
					getPlaylist();
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
 
 
 
//플레이리스트가져오기
function getPlaylist(){
	$.ajax({
		type:"post",
		url:"mymusic.do",
		data:"user_info_code="+user_info_code,
		dataType:"xml",
		success:function(data){
			
			$(".plistli").remove();
			var li="";
			$(data).find("playlist").each(function(){
				li+="<li class='plistli' id='"+$(this).find("playlist_code").text()+ "'><a href=#>";
				/* li+="<font color='white' size='3'>"+$(this).find("playlist_title").text()+"</font></li>"; */
				li+="<p>"+$(this).find("playlist_title").text()+"</p></a></li>";
				
			});				
			$("#makeplaylist2").after(li);
			
			
		},
		error:function(){
			
		}
		
	});
}//플레이리스트 가져오기
 
</script>
 
<style type="text/css">
table {
	table-layout: fixed;
	position:fixed;
	left: 300px;
	top: 200px;
	width:600px;
}
ul{
	list-style: none;
}
li:hover{
	cursor: pointer;
}
</style>
</head>
 
<!--  <body oncontextmenu="return false;"> -->
 <body >
 
	<!--플레이리스트추가하기 DVI  -->
	
<div id="id01" class="w3-modal">
  <div class="w3-modal-content w3-card-8 w3-animate-zoom"
			style="max-width: 600px">
	<div class="w3-center"><br>
	<span onclick="document.getElementById('id01').style.display='none'" class="w3-closebtn w3-hover-red w3-container w3-padding-8 w3-display-topright" title="Close Modal">&times;
	</div>
	</br>
	<p class="w3-center"><font style="font-size: 25px;" class="w3-gray" >make a list</font></p>
	</br>
	<div id="makeplaylistform">
		<form id="makeform" class="w3-container">
			<input class="w3-input w3-border w3-margin-bottom" placeholder="Enter ListName" type="text" name="playlist_title">
		Selete Theme ▶ &nbsp;
			<select name="theme_code" id="themelist">
			</select>
			<input type="hidden" name="user_info_code" value="${login_vo.user_info_code }">
			<input class="w3-btn w3-right" type="button" value="confirm" id="makeplaylistbutton"
			onclick="document.getElementById('id01').style.display='none'"/>			
			<!-- <input type="button" value="창닫기" id="close"> --> 	
			</br>
			</br>
			</br>
		</form>		
	  </div>
	</div>
</div>
	<!--플레이리스트추가하기 DVI  -->
	
	<div id="container" >
		<!-- 플레이리스트목록DVI -->
		<div id="playlist" >
			<ul id="plistul" class="w3-ul w3-sidenav  w3-white w3-card-1 w3-tiny">
				<li id="makeplaylist2"><a href="#">
 <button onclick="document.getElementById('id01').style.display='block'" id ="makeplaylist" class="w3-btn w3-large">Create List!</button></a></li>			
			</ul>		
			
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
	 		<div class="">
				<table id="mlist" class="w3-table w3-striped w3-bordered w3-border w3-tiny">
					<thead>
						<tr>
							<th style="width: 30px">Num</th>
							<th style="width: 150px">Title</th>
							<th style="width: 70px">Singer</th>
							<th style="width: 20px"><input type="checkbox" id="checkAll"/>√</th>
						</tr>
					</thead>	
			</table> 
	 		</div>
		</div>
		<!--노래목록 DIV  -->		
	</div>	
</body>
</html>