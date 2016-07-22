<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE>
<html>
<head>
<meta charset=UTF-8>
<title>Insert title here</title>
<link href="http://www.w3schools.com/lib/w3.css" type="text/css" rel="stylesheet">
<style>
	#menu {
		width: 280px;
		height: 100%;
		position: fixed;
		top: 0px;
		right: -282px;
		z-index: 10;
		border: 1px solid #c9c9c9;
		background-color: white;
		text-align: center;
		transition: All 0.2s ease;
		-webkit-transition: All 0.2s ease;
		-moz-transition: All 0.2s ease;
		-o-transition: All 0.2s ease;
	}
	#menu.open {
	  right : 0px;
	}
	.close {
	  width : 50px;
	  height : 50px;
	  position : absolute;
	  right : 0px;
	  top : 0px;
	  z-index : 1;
	  background-image : url("http://s1.daumcdn.net/cfs.tistory/custom/blog/204/2048858/skin/images/close.png");
	  background-size : 50%;
	  background-repeat : no-repeat;
	  background-position : center;
	  cursor : pointer;
	}
</style>
<script type="text/javascript" src="../js/jquery-3.0.0.js"></script>
<script>
	$(function() {
		var id;
		$("input[type=button].reply").each(function(){
			$(this).on("click", function() {
				$("#menu").addClass("open");
				id = $(this).attr("name");
				
				$.ajax({
					url : "reply.do",
					type : "post",
					dataType : "json",
					data : {"playlist_code" : $(this).attr("name")},
					success : function(data){
						reply(data);
					}, 
					error : function(request,status,error){
						alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				    }
				});
			});
		});
		
		$(".close").click(function() {
			 $("#menu").removeClass("open");
		});
		
		$("#write").click(function(){
			$.ajax({
				url : "reply_write.do",
				type : "post",
				dataType : "json",
				data : {"playlist_code" : id, "pwd" : $("#pwd").val(), 
						"content" : $("#content").val()},
				success : function(data){
					$("#content").val("");
					reply(data);
				}, 
				error : function(request,status,error){
					alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			    }
			});
		});

		function reply(data){
			$("#reply_content").empty();
			for(var i=0; i<data.length; i++){
				$("<tr>").attr("id", i).appendTo($("#reply_content"));
				$("<td>").text(data[i]["id"]).appendTo($("#" + i));
				$("<td>").text(data[i]["content"]).appendTo($("#" + i));
				// 임의(${login_vo.session_id})
				if(data[i]["id"] == "test"){
					var temp_data = $("<td>");
					temp_data.appendTo($("#" + i));
					$("<input>").attr("class", "del").attr("name", data[i]["reply_code"]).attr("type", "button").val("삭제").appendTo(temp_data);
				}
				
				$("input.del").each(function(){
					$(this).on("click", function(){
						$.ajax({
							url : "reply_delete.do",
							type : "post",
							dataType : "json",
							data : {"reply_code" : $(this).attr("name"),
									"playlist_code" : id },
							success : function(data){
								reply(data);
							},
							error : function(request,status,error){
								alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
						    }
						});
					});
				});
			}
		}
	});
</script>
</head>
<body>
	<!-- 임의 -->
	<input type="button" class="reply" value="댓글" name="6">
	<div id="menu">
		<h1>댓글</h1>
		<div class="close"></div>
		<div id="ans_write">
			<table>
				<tr>
					<th>Content</th>
					<td>
						<textarea style="margin-left:10px" id="content" placeholder="Content" style="width:80%" rows="3"></textarea>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<input id="write" type="button" value="Write" style="width:100%">
					</td>
				</tr>
			</table>
		</div>
		<table class="w3-table w3-tiny w3-striped w3-bordered w3-border">
			<thead>
				<tr style="width:100%">
					<th style="width:30%">작성자</th>
					<th style="width:60%">내용</th>
					<th></th>
				</tr>
			</thead>
			<tbody id="reply_content">
				
			</tbody>
		</table>
	</div>
</body>
</html>