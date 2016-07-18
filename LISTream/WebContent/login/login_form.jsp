<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript">

	if("${result}" == "fail")
		alert("로그인 실패");
	function login(f){
		for (var i = 0; i < document.forms[0].elements.length; i++) {
			if (document.forms[0].elements[i].value.trim() == "") {
				alert(document.forms[0].elements[i].name + "이 비었습니다");
				document.forms[0].el
				ements[i].focus();
				return;
			}
		}
		f.action = "login.do";
		f.submit();
		
		
	}
	
	function register(f){
		f.action = "register_view.do";
		f.submit();
	}
</script>
</head>
<body>
	<h1>로그인 페이지</h1>
	<hr/>
	<form method="post">
		<table border="1px solid black" style="width:700px; text-align: center">
			<tr>
				<td>아이디</td>
				<td><input type="text" name="id"></td>
			</tr>
			<tr>
				<td>비밀번호</td>
				<td><input type="password" name="pwd"></td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="button" value="로그인" onclick="login(this.form)">
					<input type="button" value="회원가입" onclick="register(this.form)">
				</td>
			</tr>
		</table>
	</form>
</body>
</html>