<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
	function register(f){
		for (var i = 0; i < document.forms[0].elements.length; i++) {
			if (document.forms[0].elements[i].value.trim() == "") {
				alert(document.forms[0].elements[i].name + "이 비었습니다");
				document.forms[0].elements[i].focus();
				return;
			}
		}
		
		var chk_id = duplicate_chk("r");
		var chk_pwd = pwd_check("r");
		
		if(chk_id){
			if(chk_pwd){
				alert("가입에 성공하셨습니다");
				f.action = "register_ok.do";
				f.submit();
			} else {
				alert("password 중복을 확인 바람");
			}
		} else {
			alert("id 중복을 확인 바람");
		}
	}
	
	function duplicate_chk(chk){

		var list = new Array();
		<c:forEach var="item" items="${list}">
			list.push("${item.id}");
		</c:forEach>
		
		for(var i=0; i<list.length; i++){
			if(list[i] == f.id.value){
				alert("id 중복");
				return false;
			}
		}
		if(chk != "r")
			alert("사용 가능합니다");
		
		return true;
	}
	
	function pwd_check(chk){
		if(f.pwd.value.length > 2){
			if(f.pwd.value == f.pwd_chk.value){
				if(chk != "r")
					alert("사용 가능합니다");
				return true;
			} else {
				alert("값이 다릅니다");
				return false;
			}
		} else {
			alert("7자리 이상");
			return false;
		}
	}
</script>
</head>
<body>
	<h1>회원가입 페이지</h1>
	<hr/>
	<form method="post" name="f">
		<table border="1px solid black" style="width:700px; text-align: center">
			<tr>
				<th>아이디</th>
				<th><input type="text" name="id">&nbsp;&nbsp;&nbsp;<input type="button" value="중복확인" onclick="duplicate_chk()"></th>
			</tr>
			<tr>
				<th>비밀번호</th>
				<th><input type="password" name="pwd"></th>
			</tr>
			<tr>
				<th>비밀번호 확인</th>
				<th><input type="password" name="pwd_chk">&nbsp;&nbsp;&nbsp;<input type="button" value="확인" onclick="pwd_check()"></th>	
			</tr>
			<tr>
				<th>이름</th>
				<th><input type="text" name="name"></th>
			</tr>
			<tr>
				<th>email</th>
				<th><input type="text" name="email"></th>
			</tr>
			<tr>
				<td colspan="2">
					<input type="button" value="회원가입" onclick="register(this.form)">
				</td>
			</tr>
		</table>
	</form>
</body>
</html>