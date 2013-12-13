<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="classes.EventClass" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
%>

<jsp:useBean id="users" scope="application" class="beans.UsersBean" />
<jsp:useBean id="currentUser" scope="session" class="beans.UserBean" />
<jsp:useBean id="events" scope="application" class="beans.EventsBean"/>

<%
	EventClass event = null;
	if (request.getParameter("eventID") != null) {
		event = events.getEventById(request.getParameter("eventID"));
	} else {
		response.sendRedirect("/home.jsp");
	}
%>

<html>
<head>
	<meta charset="utf-8">
	<title>Informations sur l'évènement</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="description" content="">
	<meta name="author" content="">

	<!-- Le styles -->
	<link href="bootstrap/css/bootstrap.css" rel="stylesheet">
	<style type="text/css">
	  body {
	    padding-top: 100px;
	    padding-bottom: 40px;
	  }
	  .sidebar-nav {
	    padding: 9px 0;
	  }
	</style>
	<link href="bootstrap/css/bootstrap-theme.css" rel="stylesheet">
</head>

<body>
	<%-- The site's banner --%>
	<div class="navbar navbar-inverse navbar-fixed-top">
   		<div class="container">
     		<div class="navbar-header">
			 	<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
	         		<span class="icon-bar"></span>
			        <span class="icon-bar"></span>
			        <span class="icon-bar"></span>
		       	</button>
		       	<a class="navbar-brand" href="home.jsp"><img id="logo" alt="logo" src="bootstrap/img/LogoMN.png"><span id="movin"> Movin'</span><span id="nantes">Nantes</span></a>
     		</div>
     		<div class="navbar-collapse collapse">
     			<%-- Buttons if a user is logged in --%>
     			<% if(user != null) { %>
       			<ul class="nav navbar-nav navbar-right">
       				<li><a href="home.jsp" class="btn btn-primary btn-small btn-nav">Accueil</a></li>
					<li>&nbsp;</li>
         			<li><a href="profile.jsp" class="btn btn-warning btn-small btn-nav">Profil</a></li>
					<li>&nbsp;</li>
         			<li><a href="<%= userService.createLogoutURL("/index.jsp") %>" class="btn btn-danger btn-small btn-nav">Déconnexion</a></li>
       			</ul>
       			<%-- Buttons if no user is logged in --%>
       			<% } else { %>
       			<ul class="nav navbar-nav navbar-right">
       				<li><a href="index.jsp" class="btn btn-primary btn-small btn-nav">Accueil</a></li>
					<li>&nbsp;</li>
         			<li><a href="<%= userService.createLoginURL("/home.jsp") %>" class="btn btn-success btn-small btn-nav">Connection</a></li>
       			</ul>
       			<% } %>
     		</div><!--/.nav-collapse -->
		</div>
	</div>
	
    <%-- The page's content --%>
    <div class="container">
  		<div class="row">
	        <div class="col-sm-8">
          		<div class="panel panel-primary">
		            <div class="panel-heading">
	              		<h3 class="panel-title">Evènement proposé par <%= event.getOrganisateur().getName() %> :</h3>
		            </div>
		            <div class="panel-body">
	              		<p><span class="label label-default">Activité</span> : <%= event.getSport() %><br><br>
	              		<span class="label label-success">Lieu</span> : <%= event.getLieu() %><br><br>
	              		<span class="label label-info">Date</span> : <%= event.getDateString() %><br><br>
	              		<span class="label label-warning">Places restantes</span> : <%= event.getPlaces() %>
	              		<%
	              			if (user != null
	              				&& 
	              				(currentUser.getEventCreatedById(event.hashCode()) == null)) {
	              		%>
	              				<form method="post" action ="/home.jsp" style="float:right">
   									<input type="hidden" name="eventID" value="<%= event.hashCode() %>"/>
   									<%
   										if (currentUser.getEventJoinedById(event.hashCode()) != null) {
   									%>
		   									<button type="submit" class="btn btn-danger">Désinscription</button>
		   									<%
   										} else {
   											if (event.getPlaces() > 0)
		   									%>
		   									<button type="submit" class="btn btn-success">Inscription</button>
		   									<%
   										}
		   									%>
		              			</form>
		              	<%
	              			}
		              	%>
		              	<%//TODO faire le lien avec la carte%>
					</div>
          		</div>
			</div>
			<div class="col-sm-4">
          		<div class="panel panel-default">
	            	<div class="panel-heading">
	              		<h3 class="panel-title">Descriptif :</h3>
	            	</div>
	            	<div class="panel-body">
	              		<p><%= event.getDescription() %></p>
	            	</div>
	          	</div>
	        </div>
		</div>
      	<hr>

		<%-- The site's footer --%>
      	<jsp:include page="footer.jsp"/>

    </div><!--/.fluid-container-->

    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="bootstrap/js/jquery.js"></script>
    <script src="bootstrap/js/bootstrap.js"></script>
    <script>
        $("#movin").css("color", "orange");
        $("#nantes").css("color", "green");
        $(".btn").css("color", "white");
		$(".btn-nav").css("margin-top", "9px");
		$("#logo").css("height", "40px");
    </script>

</body>
</html>
