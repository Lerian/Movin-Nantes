<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
	<head>
		<link rel="stylesheet" type="text/css" href="style.css" />
	</head>
	<body>
	  
	  	<%-- The site's banner --%>
		<a href="home.jsp">
			<img class="banner" src="banner.jpg" alt="La bannière devrait apparaître ici" title="Movin'Nantes, un site qu'il est bien pour organiser une rencontre sportive!" />
		</a>
		  	
		<%-- Checking if the user is logged in or not --%>
		<%
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		if (user != null) {
			pageContext.setAttribute("user", user);
			%>
				
			<%-- The user is logged in --%>
			<p>
				<a href="profile">
					<button type="button">Edit your profile</button>
				</a>
				<br/>
				<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">
					<button type="button">Sign out</button>
				</a>
			</p>
			<div id="myEvents">
				<p>La liste des events organisés par l'utilisateur apparaîtra ici.</p>
			</div>
			<div id="myInscriptions">
				<p>La liste des events où l'utilisateur est inscrit apparaîtra ici.</p>
			</div>
				
			<%
		} else {
			%>
			
			<%-- The user isn't logged in --%>
			
			<%-- The site's description --%>
			<p>
				<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">
					<button type="button">Sign in with a Google account</button>
				</a>
			</p>
			<div id="description">
				<p>
					Movin'Nantes permet en quelques clics d'organiser des rencontres sportives à Nantes.
				</p>
			</div>
			<%
		}
		%>
	
		<div class="nextEvents">
			<p>La liste des événements proches devra apparaître ici</p>
		</div>
	
	</body>
</html>