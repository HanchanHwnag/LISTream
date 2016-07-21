<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
	function go_music_register(){
		window.open("music_view.do", "", "width=230, height=250, toolbar=no, scrollbar=yes"); 
	}
	function go_manage_user(){
		window.open("user_list_view.do", "", "width=430, height=500, toolbar=no, scrollbar=yes"); 
	}
	function go_search_music(){
		location.href="search_music_view.do";
	}
</script>
</head>
<body>
	<input type="button" value="음악검색" onclick="go_search_music()">
	
	<c:if test="${login_vo.id == 'admin1' || login_vo.id == 'admin2' || login_vo.id == 'admin3' || login_vo.id == 'admin4' || login_vo.id == 'admin5'}">
		<input type="button" onclick="go_music_register()" value="음악 등록">
		<input type="button" onclick="go_manage_user()" value="회원 관리">
	</c:if>
</body>
</html>
