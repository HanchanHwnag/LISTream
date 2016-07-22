<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="w3.css">
<title>Insert title here</title>
<script src="../js/jquery-3.0.0.js"></script>
<script src="../js/jquery.audioControls.min.js"></script>
<script type="text/javascript">	
function getCodeAndPlay(playlist_code){
	$(document).ready(function() {
		$.ajax({
			url: "select_musics_to_play.do",
			data: {'playlist_code':playlist_code},
			type: "get",
			dataType: "html",
			contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
			success: function(data){

				$("#playPause").click();
				
				$("#playerDiv2").remove();
				$("#playerDiv1").html("<div id='playerDiv2'></div>");
				$("#playerDiv2").html(data);
				$("#playListContainer").audioControls({
					autoPlay : true,
					timer : 'increment',
					onAudioChange : function(response) {
						$('.songPlay').text(response.title + ' ...'); //Song title information
					},
					onVolumeChange : function(vol) {
						var obj = $('.volume');
						if (vol <= 0) {
							obj.attr('class', 'volume mute');
						} else if (vol <= 33) {
							obj.attr('class', 'volume volume1');
						} else if (vol > 33 && vol <= 66) {
							obj.attr('class', 'volume volume2');
						} else if (vol > 66) {
							obj.attr('class', 'volume volume3');
						} else {
							obj.attr('class', 'volume volume1');
						}
					}
				});
			},
			error: function(request,status,error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
				
	});
}
		function show() {
			document.getElementById("listContainer").classList.toggle("show");
		}
function start_go(){
		$(document).ready(function() {
			$(function() {
				var playlist_code = 
					$.ajax({
						url: "select_musics_to_play.do",
						data: {'playlist_code':"3"},
						type: "get",
						dataType: "html",
						contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
						success: function(data){
							$("#playerDiv2").html(data);
							$("#playListContainer").audioControls({
								autoPlay : false,
								timer : 'increment',
								onAudioChange : function(response) {
									$('.songPlay').text(response.title + ' ...'); //Song title information
								},
								onVolumeChange : function(vol) {
									var obj = $('.volume');
									if (vol <= 0) {
										obj.attr('class', 'volume mute');
									} else if (vol <= 33) {
										obj.attr('class', 'volume volume1');
									} else if (vol > 33 && vol <= 66) {
										obj.attr('class', 'volume volume2');
									} else if (vol > 66) {
										obj.attr('class', 'volume volume3');
									} else {
										obj.attr('class', 'volume volume1');
									}
								}
							});
						},
						error: function(request,status,error){
							alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
						}
					});
				});
			
		});
}

function w3_open() {
    document.getElementById("mySidenav").style.display = "block";
}
function w3_close() {
    document.getElementById("mySidenav").style.display = "none";
}


</script>

<style type="text/css">
* {
	padding: 0px;
	margin: 0px;
}
/* 
body {
	background-color: #999999;
	font-family: SourceSansPro-Regular, Helvetica, Arial, 'sans-serif';
	font-size: 14px;
	line-height: 1.428571429;
} */
ul, li {
	list-style: none;
}

.mainContainer {
	margin: 0 auto;
	width: 100%;
}

.containerPlayer, .containerSource {
	display: inline-block;
	float: left;
	padding: 0px;
	margin: 0px 0px;
	width: 100%;
}

.snippet {
	width: 70%;
	border: 1px solid #ccc;
	border-radius: 5px;
	min-height: 100px;
	max-height: 100px;
	color: #fff;
	background-color: #343434;
	margin-top: 1rem;
}

.snippet:nth-child(2) {
	margin-top: 2rem;
}

.snippet pre {
	max-height: 230px;
	padding: 5px;
}

.snippet h4 {
	padding: 10px;
	color: #343434;
	background-color: #00bd9b;
}

/* Playlist */
#listContainer {
	float: right;
	width: 25%;
	background-color: #fafafa;
	position: relative;
}

#listContainer ul {
	background-color: #fafafa;
	clear: both;
	cursor: pointer;
}

#listContainer li {
	padding: 5px;
}

#listContainer li:nth-child(even) {
	background-color: #efefef;
}

#listContainer li:hover, #listContainer li:nth-child(even):hover {
	background-color: #00bd9b;
	color: #fff;
}

#listContainer li a {
	text-decoration: none;
	color: #4e4f4f;
}

#listContainer li.activeAudio {
	background-color: #00bd9b;
}

/* Player Controls */
#playerContainer {
	width: 100%;
	height: 50px;
	background-color: #333333;
}

.controls li:first {
	margin-right: 5px;
}

.controls li {
	display: inline-block;
	text-align: center;
	margin-top: 8px;
	margin-left: 20px
}

.controls li a {
	display: inline-block;
}

.pauseAudio, .play {
	background: url('../images/audio/audio_icons.png') no-repeat -2px -35px;
	width: 32px;
	height: 32px;
	margin: auto;
}

.pauseAudio:hover {
	background: url('../images/audio/audio_icons.png') no-repeat -2px -3px;
}

.playAudio {
	background: url('../images/audio/audio_icons.png') no-repeat -36px -35px;
	width: 32px;
	height: 32px;
	margin: auto;
}

.playAudio:hover {
	background: url('../images/audio/audio_icons.png') no-repeat -36px -3px;
}

.shuffle {
	background: url('../images/audio/audio_icons.png') no-repeat -28px -96px;
	width: 32px;
	height: 32px;
	margin: auto;
}

.shuffleActive, .shuffle:hover {
	background: url('../images/audio/audio_icons.png') no-repeat -28px -71px;
	width: 32px;
	height: 32px;
	margin: auto;
}

.left {
	background: url('../images/audio/audio_icons.png') no-repeat -60px -99px;
	width: 24px;
	height: 24px;
	margin: auto;
	margin-top: 4px;
	opacity: 0.4;
}

.left:not (.disabled ):hover {
	opacity: 1;
}

.left.disabled, .right.disabled {
	opacity: 0.4;
	cursor: default;
}

.right {
	background: url('../images/audio/audio_icons.png') no-repeat -88px -75px;
	width: 24px;
	height: 24px;
	margin: auto;
	margin-top: 4px;
	opacity: 0.4;
}

.right:not (.disabled ):hover {
	opacity: 1;
}

.repeat {
	background: url('../images/audio/audio_icons.png') no-repeat -4px -103px;
	width: 21px;
	height: 21px;
	margin: auto;
	margin-top: 7px;
}

.repeat:hover, .repeat.loopActive {
	background: url('../images/audio/audio_icons.png') no-repeat -4px -79px;
}

.repeat {
	background: url('../images/audio/audio_icons.png') no-repeat -4px -103px;
	width: 21px;
	height: 21px;
	margin: auto;
	margin-top: 7px;
}

.volume {
	width: 20px;
	height: 20px;
	margin-left: 5px;
	margin-right: 5px;
	float: left;
	background: url('../images/audio/audio_icons.png') no-repeat;
}

.volume1 {
	background-position: -5px -150px;
}

.volume2 {
	background-position: -5px -198px;
}

.volume3 {
	background-position: -5px -246px;
}

.mute {
	background-position: -34px -127px;
}

.nowplay {
	background: url('../images/audio/list_icon_disabled.png') no-repeat;
	background-size: 16px 16px;
	width: 24px;
	max-width: 100%;
	height: 24px;
	margin: auto;
	margin-top: 7px;
	padding-top: 5px;
	opacity: 1;
}

.nowplay:hover, .nowplay.loopActive {
	background: url('../images/audio/list_icon_active.png') no-repeat;
}

.progress {
	clear: both;
	height: 6px;
	background-color: #666666;
	width: 100%;
	cursor: pointer;
	position: relative;
}

.progress .updateProgress {
	width: 0px;
	background-color: #00BD9B;
	height: 100%;
	float: left;
	position: relative;
}

.volumeControl {
	float: right;
	position: relative;
	margin: 10px auto;
	padding-right: 15px;
}

.volumeControl .updateProgress {
	display: inline-block;
	vertical-align: middle;
	margin-top: 5px;
}

input[type="range"] {
	margin-top: inherit;
	-webkit-appearance: none;
	-moz-appearance: none;
	background-color: #00BD9B;
	height: 2px;
}

.audioDetails {
	clear: both;
	color: #00bd9b;
	font-size: 12px;
	padding: 16px;
	float: left;
	width: 25%;
}

.audioTime {
	display: inline-block;
	text-align: right;
	float: right;
}

.songPlay {
	display: inline-block;
}

.seekableTrack {
	width: 0%;
	background-color: #666666;
	height: 4px;
	position: absolute;
	z-index: 0;
	display: block;
}

.seekableTrack, .progress .updateProgress {
	-webkit-transition: width 0.6s ease;
	-moz-transition: width 0.6s ease;
	-o-transition: width 0.6s ease;
	transition: width 0.6s ease;
}

#playListContainer {
	max-height: 224px;
	overflow: scroll;
}

#nowplay {
	margin: 0px;
	padding: 0px;
}

.rb { /* right bottom position */
	position: fixed;
	bottom: 0;
	width: 100%;
}

.show {
	display: none;
}


iframe {
	border: none;
	position: fixed;
	
	top:100px;
	width: 100%;
	height: 90%;
	z-index: 0;
}

.sidemenu{
	margin : 20px;
	background-color: #333333;

	width: 180px;
	/* border-top-left-radius: 10px;
	border-top-right-radius: 10px; */
	border-radius: 10px 10px 10px 10px;
}
.sidemenu li{
 	color: white;
	width : 100%;
	padding-top:20px;
	padding-bottom:20px;
	
	margin: 0px;
	position:relative;
	text-align: center;
	/* background-color: skyblue; */
}
.sidemenu li:hover{
	background-color: #00bd9b;
}
.headerbar{
	width: 95%;
	height: 80px;
	margin-top: 20px;
	margin-right: 20px;
	margin-left: 20px;
	background-color: #333333;
	color: white;
	
	border-radius: 10px 10px 10px 10px;
	
}
/* .headerbar a{
	padding: 20px;
}
 */
</style>

</head>
<body onload="start_go()">

<nav class="w3-sidenav w3-white w3-card-2 w3-animate-right" style="display:none" id="mySidenav">
  <a href="javascript:void(0)" onclick="w3_close()"
  class="w3-closenav w3-large">Close &times;</a>
  <a  href="../music/search_music.jsp" target="frame" onclick="w3_close()">Music Search</a>
  <a href="../mymusic/mymusic.jsp" target="frame" onclick="w3_close()">My Music</a>
  <a href="searchPlayListView.do" target="frame" onclick="w3_close()">Playlist View</a>
  <a href="favorite.do" target="frame" onclick="w3_close()">follow list</a>
</nav>

<header class="w3-container w3-teal">
  <span class="w3-opennav w3-xlarge" onclick="w3_open()">&#9776;</span>
  <h1>${login_vo.name } page</h1>
</header>

	<iframe name="frame" id="frame" src="../music/search_music.jsp"></iframe>
	<%-- <div class= "headerbar">
		<a style="font-size: 30px; padding: 20px;">${login_vo.name } 님 page</a>
		<div style=" float:right; right:40px;">
			<a style=" color:white">[개인정보수정]</a> ||
			<a style="color:white" href="../login/login_form.jsp">[log-out]&nbsp;&nbsp;&nbsp;</a>
		</div>
	</div>
	
	<div>
	<ul class="sidemenu">
		<li style=" border-top-left-radius: 10px;
	border-top-right-radius: 10px; color: white;"><p><a href="../music/search_music.jsp" target="frame">검색</a></p></li>
		<li><a>장르별</a></li>
		<li id="myMusic"><a href="../mymusic/mymusic.jsp" target="frame">내 노래</a></li>
		<li><button>2</button></li>
		<li style = "border-bottom-left-radius: 10px;
	border-bottom-right-radius: 10px;"><button>2</button></li>
	</ul>
	</div> --%>
	
	<div id="playerDiv1" style="position:fixed; bottom:0px; width:100%;">
		<div id="playerDiv2">
		</div>
	</div>
	
</body>
</html>