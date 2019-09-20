<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ include file="config.jsp" %>
<%

Object user_id = session.getAttribute("user_id");
if (user_id != null) {
	response.sendRedirect("home.jsp");
}

String username = null;
if (request.getParameter("registered") != null) {
	username = request.getParameter("registered");
}
if (request.getParameter("username") != null) {
	username = request.getParameter("username");
}

Connection connect = null;
Statement statement = null;

String error_text = null;

if ("POST".equalsIgnoreCase(request.getMethod())) {
	try {
		Class.forName("com.mysql.jdbc.Driver");
		connect =  DriverManager.getConnection("jdbc:mysql://" + mysql_host + "/" + mysql_db + "" +"?user=" + mysql_username + "&password=" + mysql_password);
		statement = connect.createStatement();
		ResultSet result = statement.executeQuery("SELECT * FROM `users` WHERE `username` = '" + request.getParameter("username") + "' AND `password` = '" + request.getParameter("password") + "';");
		if (result.next()) {
			session.setAttribute("user_id", result.getString("id"));
			if (request.getParameter("remember_me") != null) {
				session.setMaxInactiveInterval(86400);
			} else {
				session.setMaxInactiveInterval(900);
			}
			response.sendRedirect("home.jsp");
		} else {
			error_text = "ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง";
		}
	}  catch (Exception e) {
		error_text = e.getMessage();
	}
	try {
		if (statement != null){
			statement.close();
			connect.close();
		}
	} catch (SQLException e) {
	}
}

%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>ลงชื่อเข้าใช้</title>
    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/css/floating-labels.css" rel="stylesheet">
	<link href="assets/css/style.css" rel="stylesheet">
	<script defer src="assets/js/all.js"></script>
</head>

<body>
    <form action="login.jsp" method="POST" class="form-signin">
        <div class="text-center mb-4">
            <i class="fas fa-user fa-4x mb-3" ></i>
            <h1 class="h3 mb-2 font-weight-normal">ยินดีต้อนรับ</h1>
            <p>โปรดลงชื่อเข้าใช้ เพื่อดำเนินการต่อ</p>
        </div>
		<%

		if (error_text != null) {
		%>
		<div class="alert alert-danger alert-dismissible fade show" role="alert">
			<i class="fas fa-exclamation-triangle"></i>&nbsp; <%=error_text%>
			<button type="button" class="close" data-dismiss="alert" aria-label="Close">
				<span aria-hidden="true">&times;</span>
			</button>
		</div>
		<%
		} else if (request.getParameter("registered") != null) {
		%>
		<div class="alert alert-success alert-dismissible fade show" role="alert">
			<i class="fas fa-info-circle"></i>&nbsp; สมัครผู้ใช้ใหม่สำเร็จ โปรดลงชื่อเข้าใช้
			<button type="button" class="close" data-dismiss="alert" aria-label="Close">
				<span aria-hidden="true">&times;</span>
			</button>
		</div>
		<%
		}
		%>
        <div class="form-label-group">
            <input type="text" name="username" id="username" class="form-control" placeholder="ชื่อผู้ใช้" value="<% if (username != null) { out.print(username); } %>" required <% if (request.getParameter("registered") == null) { out.print("autofocus"); } %>>
            <label for="username">ชื่อผู้ใช้</label>
        </div>

        <div class="form-label-group">
            <input type="password" name="password" id="password" class="form-control" placeholder="รหัสผ่าน" required <% if (request.getParameter("registered") != null) { out.print("autofocus"); } %>>
            <label for="password">รหัสผ่าน</label>
        </div>

        <div class="checkbox mb-3">
            <label>
                <input type="checkbox" name="remember_me" value="true" <% if (request.getParameter("remember_me") != null) { out.print("checked"); } %>> จดจำบัญชีของฉัน
            </label>
        </div>
        <button class="btn btn-lg btn-primary btn-block" type="submit">ลงชื่อเข้าใช้</button>
		<p class="mt-2 small text-center">ไม่มีบัญชีผู้ใช้? <a href="register.jsp">สมัครผู้ใช้ใหม่</a></p>
        <p class="mt-3 small text-muted text-center">&copy; 2019 Likecyber</p>
    </form>
	<script defer src="assets/js/jquery-3.4.1.min.js"></script>
	<script defer src="assets/js/bootstrap.min.js"></script>
</body>

</html>
