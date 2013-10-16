<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
	<head>
		<link rel="stylesheet" type="text/css" href="style.css" />
		<title>Edit your profile</title>
	</head>
	<body>
	  
	  	<%-- The site's banner --%>
		<a href="home.jsp">
			<img class="banner" src="banner.png" alt="La bannière devrait apparaître ici" title="Movin'Nantes, un site qu'il est bien pour organiser une rencontre sportive!" />
		</a>
		  	
		<%-- Checking if the user is logged in or not --%>
		<%
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		if (user != null) {
			pageContext.setAttribute("user", user);
			%>
				
			<%-- The user is logged in --%>
			<div class="headerButtonArea box">
				<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">
					<button type="button">Sign out</button>
				</a>
			</div>
			
			<div id="myPlaces" class="editProperty">
				<p>Mes lieux favoris :</p>
				<input type="checkbox" name="lieux1" id="lieux1" /> <label for="lieux1">lieux1</label><br />
				<input type="checkbox" name="lieux2" id="lieux2" /> <label for="lieux2">lieux2</label><br />
				<input type="checkbox" name="lieux3" id="lieux3" /> <label for="lieux3">lieux3</label><br />
				<input type="checkbox" name="lieux4" id="lieux4" /> <label for="lieux4">lieux4</label><br />
				<input type="checkbox" name="lieux5" id="lieux5" /> <label for="lieux5">lieux5</label><br />
				<input type="checkbox" name="lieux6" id="lieux6" /> <label for="lieux6">lieux6</label><br />
				<input type="checkbox" name="lieux7" id="lieux7" /> <label for="lieux7">lieux7</label><br />
				<input type="checkbox" name="lieux8" id="lieux8" /> <label for="lieux8">lieux8</label><br />
			</div>
			
			<div id="mySports" class="editProperty">
				<p>Mes sports :</p>
			</div>
				
			<%
		} else {
			%>
			
			<%-- The user isn't logged in --%>
			
			<%-- The site's description --%>
			<div class="headerButtonArea box">
				<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">
					<button type="button">Sign in with a Google account</button>
				</a>
			</div>
			<div id="description" class="box">
				<p>
					Movin'Nantes permet en quelques clics d'organiser des rencontres sportives à Nantes.
				</p>
			</div>
			<%
		}
		%>
	
		<div class="nextEvents box">
			<p>Prochains évènements:</p>
		</div>
	
		<!-- Javascript section
    	================================================== -->
        <!-- Placed at the end of the document to quicken the page's loading time -->
        
	
	</body>
</html>