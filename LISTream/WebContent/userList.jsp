<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<table border="1">hfg
		<tbody>
			<c:forEach var="k" items="${list }">
				<tr>
					<td>${k.user_info_code }</td>
					<td>${k.id }</td>
					<td>${k.pwd }</td>
					<td>${k.name }</td>
					<td>${k.email }</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
</html>