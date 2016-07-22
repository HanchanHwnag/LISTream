<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="w3.css">
<title>Insert title here</title>
<script type="text/javascript">
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
	width: 40%;
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
	z-index: 10;
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
	/* bottom: 0; */
	top:0;
	width: 100%;
}

.show {
	display: none;
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
<body>

<div id="" class="rb">
		<div class="containerPlayer">

			<div id="playerContainer">
				<ul class="controls">
					<div class="audioDetails">
						<span class="songPlay"></span>
						<span data-attr="timer" class="audioTime"></span>
					</div>
					<li><a href="#" class="shuffle shuffleActive"
						data-attr="shuffled"></a></li>
					<li><a href="#" class="left" data-attr="prevAudio"></a></li>
					<li><a href="#" class="play" data-attr="playPauseAudio"></a></li>
					<li><a href="#" class="right" data-attr="nextAudio"></a></li>
					<li><a href="#" class="repeat" data-attr="repeatSong"></a></li>
					<li style="float: right;"><a class="nowplay" onclick="show()"></a></li>
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
		<div id="listContainer" class="playlistContainer">
			<ul id="playListContainer">
				<li data-src="../musics/Zedd - 11 - Stay The Night (Feat. Hayley Williams of Paramore) - 192k.mp3"><a href="#">Stay The Night (Feat. Hayley Williams of Paramore)</a></li>
				<li data-src="../musics/Afrojack,Shermanology - 02 - Can`t Stop Me (Club Mix) - 192k.mp3"><a href="#">Afrojack,Shermanology - 02 - Can`t Stop Me</a></li>
			</ul>
		</div>

	</div>

	<nav class="w3-sidenav w3-white w3-card-2" style="display:none"
		id="mySidenav"> <a href="javascript:void(0)"
		onclick="w3_close()" class="w3-closenav w3-large">Close &times;</a> <a
		href="#">Link 1</a> <a href="#">Link 2</a> <a href="#">Link 3</a> <a
		href="#">Link 4</a> <a href="#">Link 5</a> </nav>

	<header class="w3-container w3-grey"> <span
		class="w3-opennav w3-xlarge" onclick="w3_open()">&#9776;</span>
	
	</header>

	<div class="w3-container">
		<p>In this example, the sidenav is hidden (style="display:none")
			and is only shown when you click on the menu icon in the top left
			corner. When it is opened, it hides a part of the page content (it
			lays on top of it).</p>
	</div>

	<!-- 
	<iframe src="main.jsp"  width="100%" style="height:800px; border:none; z-index: 0;" ></iframe>
	 -->
	
	<footer class="w3-container w3-teal">
	<h5>Footer</h5>
	<p>Footer information goes here</p>
	</footer>
</body>
</html>