<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style type="text/css">
html, body {
	height: 100%;
	margin: 0;
	font-size: 20px;
}

#left {
	width: 20%;
	height: 100%;
	position: fixed;
	outline: 1px solid;
	background: red;
}
</style>
</head>
<body>
	<div id="left">Side menu</div>
	<div id="audioPlayer"></div>
	
	<%response.sendRedirect("userList.do"); %>
</body>
</html>