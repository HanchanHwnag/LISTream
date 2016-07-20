<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

<%
response.sendRedirect("mymusic.do?user_info_code=2");
%>

<%-- 
<jsp:forward page="mymusic.do">
	<jsp:param value="user_info_code" name="2"/>
</jsp:forward>
 --%>
</body>
</html>