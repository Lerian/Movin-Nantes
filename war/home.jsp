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
		<title>Moving'Nantes</title>
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
	    <link href="bootstrap/css/bootstrap-responsive.css" rel="stylesheet">
	</head>
	<body>
		  	
		<%-- Checking if the user is logged in or not --%>
		<%-- 	If the result is positive, checks if the user is already in the datastore, put him in if not --%>
		<%
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		if (user != null) {
			pageContext.setAttribute("user", user);
			
		    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			
			Query query = new Query("User");
			query.addFilter("email", FilterOperator.EQUAL, user.getEmail());
			PreparedQuery pq = datastore.prepare(query);
			if (pq.asSingleEntity() == null) {
				Key userKey = KeyFactory.createKey("User", user.getNickname());
			    Entity userEntity = new Entity("User", userKey);
			    userEntity.setProperty("email", user.getEmail());
			 
			    datastore.put(userEntity); //save it
			}
		}
		%>
		
		<%-- Constructing the top bar --%>
		
		<div class="navbar navbar-inverse navbar-fixed-top">
			<div class="navbar-inner">
				<div class="container-fluid">
					<a class="brand" href="home.jsp"><h1>Movin'Nantes</h1></a>
					<ul class="nav pull-right">
					
						<% if (user != null) { %>
							<li class="divider-vertical"></li>
							<li><a href="profile.jsp" class="btn btn-warning btn-small">Profil</a></li>
							<li class="divider-vertical"></li>
							<li>
								<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>" class="btn btn-danger btn-small">Déconnexion</a>
							</li>
						<% } else { %>
							<li class="divider-vertical"></li>
							<li>
								<a href="<%= userService.createLoginURL(request.getRequestURI()) %>" class="btn btn-warning btn-small">Connexion</a>
							</li>
						<% } %>
						
					</ul>
				</div>
			</div>
		</div>
		
		<%-- Constructing the page content --%>
		
		<div class="container-fluid">
      		<div class="row-fluid">
      			<% if (user != null) { %>
		        	<div class="span4 well">
		            	<h2>Mes évènements :</h2>
		            	<hr>
		              	<p>bla<br>bla<br>bla</p>
		              	<p><a href="#addeve" class="btn btn-info" data-toggle="modal">Ajouter un évènement &raquo;</a></p>
		            </div>
		            <div class="span4 well">
		            	<h2>Mes inscriptions :</h2>
		            	<hr>
		              	<p>bla<br>bla<br>bla</p>
		            </div>
		        <% } else { %>
		        	<div class="span4 well">
		            	<h2>Présentation de l'appli</h2>
		              	<p>bla bla bla</p>
		            </div>
		        <% } %>
	            <div class="span4 well">
	              	<h2>Prochains évènements :</h2>
	              	<hr>
	              	<p>bla<br>bla<br>bla</p>
	        	</div>
      		</div>
      
      		<%-- PopUp d'ajout d'évènement --%>
      		
        	<div class="modal hide fade" id="addeve" tabindex="-1">
            	<div class="modal-header">
                	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                	<h3>Ajout d'un évènement :</h3>
            	</div>
            	<div class="modal-body">
                	<p>
	                    <form>
	                        <input type="text" placeholder="Sport">
	                        <input type="text" placeholder="Lieu">
	                        <input type="text" placeholder="Date">
	                        <input type="text" placeholder="Nombre de place">
	                        <input type="text" placeholder="Description">
	                    </form>
                	</p>
            	</div>
            	<div class="modal-footer">
                	<a href="#" class="btn btn-primary" data-dismiss="modal" aria-hidden="true">Ajouter !</a>
            	</div>
        	</div>
        
      		<hr>

			<%-- Footer --%>

      		<footer>
        		<p>&copy;Vincent RAVENEAU, Coraline MARIE, Quentin MORICEAU - M1 ALMA 2013</p>
      		</footer>

    	</div><!--/.fluid-container-->

    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="bootstrap/js/jquery.js"></script>
    <script src="bootstrap/js/bootstrap.js"></script>
		
	</body>
</html>