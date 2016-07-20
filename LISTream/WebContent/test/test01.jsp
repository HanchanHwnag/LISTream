<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style type="text/css">
.test {
	background-color: lime;
	width: 200px;
	text-decoration: underline;
	text-align: right;
	color: purple; /*글자색*/
}

.line {
	border: solid 1px blue; /*직선 굵기 선색*/
}

#wrap {
	background-color: orange;
	width: 300px;
	height: 300px;
}
</style>
</head>
<body>
	<div class=test>사과</div>
	<span class=test>바나나</span>
	<pre class=test>딸기</pre>
	
	<input type="text" class="line">
	<input type="password" class="line">
	
	<div id="wrap"></div>
</body>
</html>