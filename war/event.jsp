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
	<title>Test HTML Appli web</title>
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
       				<li><a href="home.jsp" class="btn btn-warning btn-small btn-nav">Accueil</a></li>
					<li>&nbsp;</li>
         			<li><a href="profile.jsp" class="btn btn-warning btn-small btn-nav">Profil</a></li>
					<li>&nbsp;</li>
         			<li><a href="<%= userService.createLogoutURL("/index.jsp") %>" class="btn btn-danger btn-small btn-nav">Déconnexion</a></li>
       			</ul>
       			<%-- Buttons if no user is logged in --%>
       			<% } else { %>
       			<ul class="nav navbar-nav navbar-right">
       				<li><a href="index.jsp" class="btn btn-warning btn-small btn-nav">Accueil</a></li>
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
	              		<p>Activité : <%= event.getSport() %><br>
	              		Lieu : <%= event.getLieu() %><br>
	              		Date : <%= event.getDate() %><br>
	              		Places restantes : <%= event.getPlaces() %><br>
	              		<%= event.getDescription() %></p>
		              	<a href="#" class="btn btn-primary">S'inscrire</a>
		              	<% //TODO faire l'inscription 
		              		//TODO faire le lien avec la carte%>
					</div>
          		</div>
			</div>
			<div class="col-sm-4">
          		<div class="panel panel-default">
	            	<div class="panel-heading">
	              		<h3 class="panel-title">Carte :</h3>
	            	</div>
	            	<div class="panel-body">
	              		<p style="text-align:center"><iframe width="300" height="300" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="https://maps.google.fr/maps?f=q&amp;source=s_q&amp;hl=fr&amp;geocode=&amp;q=47.248810,+-1.564139&amp;aq=&amp;sll=47.22531,-1.554651&amp;sspn=0.019702,0.045447&amp;ie=UTF8&amp;hq=&amp;hnear=47.248810,+-1.564139&amp;t=m&amp;ll=47.212572,-1.557312&amp;spn=0.139927,0.205994&amp;z=11&amp;output=embed"></iframe></p>
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
