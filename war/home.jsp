<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
  <body>
  
  	<a href="home.jsp">
  		<img src="banner.jpg" alt="La bannière devrait apparaître ici" title="Movin'Nantes, un site qu'il est bien pour organiser une rencontre sportive!" />
  	</a>
  	
  	<p>Une description du site devra apparaître ici.</p>
  	
  	<%-- Checking if the user is logged in or not --%>
	<%
	    UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();
	    if (user != null) {
	      pageContext.setAttribute("user", user);
	%>
	
	<%-- The user is logged in --%>
	<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
	<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
	<%
	    } else {
	%>
	
	<%-- The user isn't logged in --%>
	<p>
		<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">
			<button type="button">Sign in with a Google account</button>
		</a>
	</p>
	<%
	    }
	%>

  </body>
</html>