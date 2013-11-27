<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:useBean id="users" scope="application" class="beans.UsersBean" />

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Liste des utilisateurs</title>
</head>
<body>
	<%
		for(int i=0;i<users.getSize();i++) {
			%><p><% out.print(users.getUserString(i));%></p><%
		}
	%>
</body>
</html>