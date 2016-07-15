<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset=UTF-8>
<title>Insert title here</title>
<style type="text/css">
	ul {
		list-style: none;
		padding:5px;
	}
	li {
		display: inline;
	}
</style>
<script type="text/javascript" src="../js/jquery-3.0.0.js"></script>
<script type="text/javascript">
	$(function(){
		$("#del").click(function(){
			var chk_del = false;
			var del_arr = new Array();
			$(".del").each(function(){
				if($(this).is(":checked")){
					del_arr.push($(this).val());
					chk_del = true;
				}				
			});

			if(chk_del){
				var chk = confirm("정말로 삭제하시겠습니까?");
				if(chk){
					$.ajax({
						type: "post",
						url: "delete_user.do",
						data: {"del_arr" : del_arr},
						success : function(data){
							alert("삭제되었습니다");
							
							if(data == "true"){
								location.href="user_list_view.do?cPage=" + ${page.nowPage -1};
							} else {
								location.href="user_list_view.do?cPage=" + ${page.nowPage};
							}
						}, 
						error : function(request,status,error){
							alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
					    }
					});
				}
			}
		});
		
		var idx = -1;
		$("#sel").click(function(){
			idx++;
			$(".del").each(function(){
				if(idx%2 == 0){
					$(this).prop("checked", true);
				} else {
					$(this).prop("checked", false);
				}
			});
		});
		
		$("#search").keydown(function(e){
			if(e.which == 13) /* 13 -> enter key */
				search();
		});
	});
	
	
	
	function sendPage(cPage){
		location.href = "user_list_view.do?cPage=" + cPage;
	}	
	
	function search(){
		location.href = "user_list_view.do?id=" + $("#search").val();
	}
</script>
</head>
<body>
	<table style="text-align:center">
		<tr>
			<td colspan="4"><input type="text" id="search" size="35" placeholder="search"></td>
			<td><input type="button" value="search" onclick="search()"></td>
		</tr>
		<tr>
			<th>Number</th>
			<th>ID</th>
			<th>Name</th>
			<th><input id="del" type="button" value="delete"></th>
			<th><input id="sel" type="button" value="all"></th>
		</tr>
		<c:if test="${empty list}">
			<tr><td colspan="4">자료가 없습니다</td></tr>	
		</c:if>
		<c:if test="${!empty list}">
			<c:forEach var="k" items="${list}">
				<tr>
					<td>${k.r_num}</td>
					<td>${k.id}</td>
					<td>${k.name}</td>
					<td><input type="checkbox" class="del" value="${k.user_info_code}"></td>
					<td></td>
				</tr>
			</c:forEach>
		</c:if>
		<tr>
			<td colspan="4">
				<ul>
					<c:if test="${page.beginPage <= page.pagePerBlock}">
						<input type="button" value="이전으로" disabled="disabled"/>
					</c:if>
					<c:if test="${page.beginPage > page.pagePerBlock}">
						<input type="button" value="이전으로" onclick="sendPage(${page.beginPage - page.pagePerBlock})"/>
					</c:if>
				
					<c:forEach var="k" step="1" begin="${page.beginPage}" end="${page.endPage}">
						<li><a href="user_list_view.do?cPage=${k}">${k}</a></li>	
					</c:forEach>
				
					<c:if test="${page.endPage == page.totalPage}">
						<input type="button" value="다음으로" disabled="disabled"/>
					</c:if>
					<c:if test="${page.endPage != page.totalPage}">
						<input type="button" value="다음으로" onclick="sendPage(${page.beginPage + page.pagePerBlock})"/>
					</c:if>
				</ul>
			</td>
		</tr>
	</table>
</body>
</html>