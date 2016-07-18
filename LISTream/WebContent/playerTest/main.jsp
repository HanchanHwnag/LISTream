<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="../js/jquery-3.0.0.js"></script>
<script src="../js/jquery.audioControls.min.js"></script>
<script type="text/javascript">


$(function(){
	$("#addMusic").click(function(){
		$.ajax({
			url: "/LISTream/playerTest/select_musics_to_play.do",
			data: {"playerlist_code":"32"},
			type: "post",
			dataType: "html",
			contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
			success: function(data){
				$("#playListContainer").html(data);
			},
			error: function(request,status,error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	});
});
	function show() {
		document.getElementById("listContainer").classList.toggle("show");
	}

	$(document).ready(function() {
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
	});
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
	margin-left: 60px
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
	height: 4px;
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
	width: 15%;
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
</style>

</head>
<body style="background-color: red;">
	<div id="" class="rb">
		<div id="listContainer" class="playlistContainer">
			<ul id="playListContainer">
				<li data-src="">재생할 음악이 없습니다</li>
				<li data-src="/Users/hanchanhwang/MyStudy/Project2/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/LISTream/upload/성시경-03-희재.mp3"><a href="#">Can`t Stop Me (Club Mix)</a></li>
			</ul>
		</div>

		<div class="containerPlayer">

			<div id="playerContainer">
				<ul class="controls">
					<div class="audioDetails">
						<span class="songPlay"></span> <span data-attr="timer"
							class="audioTime"></span>
					</div>
					<li><a href="#" class="shuffle shuffleActive"
						data-attr="shuffled"></a></li>
					<li><a href="#" class="left" data-attr="prevAudio"></a></li>
					<li><a href="#" class="play" data-attr="playPauseAudio"></a></li>
					<li><a href="#" class="right" data-attr="nextAudio"></a></li>
					<li><a href="#" class="repeat" data-attr="repeatSong"></a></li>
					<li><a class="nowplay" onclick="show()"></a></li>
					<div class="volumeControl">
						<div class="volume volume1"></div>
						<input class="bar" data-attr="rangeVolume" type="range" min="0"
							max="1" step="0.1" value="0.7" />
					</div>

				</ul>

				<div class="progress">
					<div data-attr="seekableTrack" class="seekableTrack"></div>
					<div class="updateProgress"></div>
				</div>

			</div>
		</div>
	</div>
	<div id="aa">
		<input type="button" id="addMusic" value="재생">
		<p>1</p>
		<p>2</p>
		<p>3</p>
	</div>
</body>
</html>