<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterOperator" %>
<%@ page import="com.google.appengine.api.datastore.PreparedQuery" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
	<head>
		<link rel="stylesheet" type="text/css" href="style.css" />
		<title>Moving'Nantes Home</title>
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
			<%-- Checks if the user is already in the datastore, put him in if not --%>
			<%
		    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			
			Query query = new Query("User");
			query.addFilter("email", FilterOperator.EQUAL, user.getEmail());
			PreparedQuery pq = datastore.prepare(query);
			if (pq.asSingleEntity() == null) {
				Key userKey = KeyFactory.createKey("User", user.getNickname());
			    Entity userEntity = new Entity("User", userKey);
			    userEntity.setProperty("name", user.getNickname());
			    userEntity.setProperty("email", user.getEmail());
			 
			    datastore.put(userEntity); //save it
			}
			%>
			<div class="headerButtonArea box">
				<a href="profile.jsp">
					<button type="button">Edit your profile</button>
				</a>
				<br/>
				<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">
					<button type="button">Sign out</button>
				</a>
			</div>
			
			<form name="createEvent" class="box" id="eventCreationArea" action="" method="get">
			<fieldset>
			<legend class="underlined">Créer un nouvel évènement:</legend>
				Quoi : <input type="text" name="quoi"><br/>
				Où : <input type="text" name="ou"><br/>
				Quand : <input type="text" name="quand"><br/>
				Places : <input type="text" name="places"><br/>
				<input type="submit" value="Créer l'évènement">
			</fieldset>
			</form>
			
			<div id="myEvents" class="box">
				<p>Mes évènements:</p>
			</div>
			
			<div id="myInscriptions" class="box">
				<p>Mes inscriptions:</p>
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