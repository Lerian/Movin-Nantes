<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
	<head>
    <meta charset="utf-8">
    <title>Editer votre profile</title>
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
	<link href="bootstrap/css/typeahead.css" rel="stylesheet">

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
          		<a class="navbar-brand" href="home.html"><img id="logo" alt="logo" src="bootstrap/img/LogoMN.png"><span id="movin"> Movin'</span><span id="nantes">Nantes</span></a>
        	</div>
        	<div class="navbar-collapse collapse">
          		<ul class="nav navbar-nav navbar-right">
            		<li><a href="index.html" class="btn btn-danger btn-small btn-nav">Déconexion</a></li>
          		</ul>
        	</div><!--/.nav-collapse -->
      	</div>
    </div>
		  	
		<%-- Checking if the user is logged in or not --%>
		<%
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		if (user != null) {
			pageContext.setAttribute("user", user);
			%>
				
			<%-- The user is logged in --%>
			<div class="container">
      			<legend>Profile de XXX</legend>
	  			<div class="row">
        		<div class="col-sm-4">
          			<div class="panel panel-info">
            			<div class="panel-heading">
              				<h3 class="panel-title">Mes lieux favoris :</h3>
            			</div>
            			<div class="panel-body">
              				<p>bla<br>bla<br>bla</p>
			  				<form class="form-inline" role="form">
			    				<input class="form-control" id="lieu" type="text" placeholder="Lieu">
			    				<button href="#" class="btn btn-info btn-nav">Ajouter</button>
			  				</form>
            			</div>
          			</div>
				</div>
				<div class="col-sm-4">
          			<div class="panel panel-success">
           				 <div class="panel-heading">
              				<h3 class="panel-title">Mes sports favoris :</h3>
            			</div>
            			<div class="panel-body">
              				<p>bla<br>bla<br>bla</p>
			  				<form class="form-inline" role="form">
			    				<input class="form-control" id="sport" type="text" placeholder="Sport">
			    				<button href="#" class="btn btn-success btn-nav">Ajouter</button>
			  				</form>
            			</div>
          			</div>
        		</div>
        		<div class="col-sm-4">
          			<div class="panel panel-danger">
            			<div class="panel-heading">
              				<h3 class="panel-title">Mes évènements et inscriptions :</h3>
            			</div>
            			<div class="panel-body">
              				<p>bla<br>bla<br>bla</p>
            			</div>
          			</div>
				</div>
	  		</div>
				
			<%
		} else {
			%>
			
			<%-- The user isn't logged in --%>
			
			<% response.sendRedirect(userService.createLogoutURL("/home.jsp")); %>
			<%
		}
		%>
	
		<hr>

      <footer>
        <p>&copy; 2013 Vincent RAVENEAU, Coraline MARIE, Quentin MORICEAU - M1 ALMA <a href="http://www.univ-nantes.fr/">Université de Nantes</a></p>
      </footer>

    </div>
	
		<!-- Javascript section
    	================================================== -->
        <!-- Placed at the end of the document to quicken the page's loading time -->
        <script src="bootstrap/js/jquery.js"></script>
    	<script src="bootstrap/js/bootstrap.js"></script>
		<script src="bootstrap/js/typeahead.js"></script>
    	<script>
        	$("#movin").css("color", "orange");
        	$("#nantes").css("color", "green");
        	$(".btn").css("color", "white");
			$(".btn-nav").css("margin-top", "9px");
			$("#logo").css("height", "40px");
			$('#sport').typeahead({
		  		name: 'sports',
		  		local: ['Footing', 'Football', 'Quiditch']
			});
			$('#lieu').typeahead({
		  		name: 'lieus',
		  		local: ['The moon', 'La petite amazonie', 'Tour de Bretagne']
			});
    	</script>
	
	</body>
</html>