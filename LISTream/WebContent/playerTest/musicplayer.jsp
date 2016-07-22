<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style type="text/css">
	#a{
		width: 100%;
	}
</style>

<script src="../js/jquery-3.0.0.js"></script>
<script src="../js/jquery.audioControls.min.js"></script>
<script type="text/javascript">
function change(){
	document.getElementById("asd").setAttribute('src', "../musics/Avicii - 01 - Levels - 192k.mp3" );
	alert( getElementById("asd").text);
}
$(function(){
		
		
	});
</script>
</head>
<body>

<div>
	<ul>
		<li id = "1">aaa</li>
		<li id = "2">aaa</li>
		<li id = "3">aaa</li>
		<li id = "4">aaa</li>
		<li id = "5">aaa</li>
	</ul>
</div>

<button onclick = "change()">하하</button>

<audio controls autoplay id="a">
  <source id="asd" src="../musics/Afrojack,Shermanology - 02 - Can`t Stop Me (Club Mix) - 192k.mp3" type="audio/mpeg">
</audio>
</body>
</html>