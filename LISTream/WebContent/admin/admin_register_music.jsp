<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset=UTF-8>
<title>Insert title here</title>
<script type="text/javascript" src="../js/jquery-3.0.0.js"></script>
<script type="text/javascript">
	$(function(){
		$.ajax({
			// http://localhost:8090/SpringProject/
			url: "genre.do",
			type: "post",
			dataType: "text",
			success: function(data){
				var data = data.split("/");
				for(var i=0; i<data.length; i++){
					var t_date  = data[i].split(",");
					$("select").append("<option value='" + t_date[0] +"'>" + t_date[1] + "</option>");
				}
			},
			contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
			error: function(request,status,error){
		       	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		    }
		});
	});
	
	function register(f){
		for(var i=0; i<document.forms[0].elements.length; i++){
			if(document.forms[0].elements[i].value.trim() == ""){
				alert(document.forms[0].elements[i].name + "이 비었습니다");
				return;
			}
		}
		
		f.action = "register_music.do";
		f.submit();
		alert("등록되었습니다");
	}
</script>
</head>
<body>
	<form method="post" enctype="multipart/form-data">
		<table>
			<tr><td><h3>음악등록</h3></td></tr>
			<tr>
				<td>
					<select name="genre_code">
						<option>Genre</option>
					</select>
				</td>
			</tr>
			<tr><td><input type="text" name="artist" placeholder="artist"></td></tr>
			<tr><td><input type="text" name="music_title" placeholder="music_title"></td></tr>
			<tr><td><input type="file" name="fname"></td></tr>
			<tr style="text-align: center;"><td><input type="button" value="등록" onclick="register(this.form)"></td></tr>
		</table>
	</form>
</body>
</html>