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
	    <link href="bootstrap/css/bootstrap-theme.css" rel="stylesheet">
		<link href="bootstrap/css/datepicker.css" rel="stylesheet">
		<link href="bootstrap/css/typeahead.css" rel="stylesheet">
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
					
			<% if (user != null) { %>
			  <li><a href="profile.html" class="btn btn-warning btn-nav">Profile</a></li>
			  <li>&nbsp;</li>
              <li><a href="<%= userService.createLogoutURL(request.getRequestURI()) %>" class="btn btn-danger btn-nav">Déconexion</a></li>
			<% } else { %>
			  <li>
				<a href="<%= userService.createLoginURL(request.getRequestURI()) %>" class="btn btn-success btn-nav">Connexion</a>
			  </li>
			<% } %>
		  </ul>
        </div>
      </div>
    </div>
		
		<%-- Constructing the page content --%>
		
		<div class="container">
			<div class="row">
      			<% if (user != null) { %>
		        	<div class="col-sm-4">
          			<div class="panel panel-info">
            			<div class="panel-heading">
              				<h3 class="panel-title">Mes évènements :</h3>
            			</div>
            			<div class="panel-body">
              				<p>bla<br>bla<br>bla</p>
              				<p><a data-toggle="modal" href="#myModal" class="btn btn-info">Créer un évènement &raquo;</a></p>
            			</div>
          			</div>
					</div>
		            <div class="col-sm-4">
          			<div class="panel panel-success">
            			<div class="panel-heading">
              				<h3 class="panel-title">Mes inscriptions :</h3>
            			</div>
            			<div class="panel-body">
              				<p>bla<br>bla<br>bla</p>
            			</div>
          			</div>
        			</div>
		        <% } else { %>
		            <div class="col-sm-8">
          			<div class="panel panel-success">
            			<div class="panel-heading">
              				<h3 class="panel-title">Présentation de l'appli</h3>
            			</div>
            			<div class="panel-body">
              				<p>bla bla bla</p>
            			</div>
          			</div>
        			</div>
		        <% } %>
	            <div class="col-sm-4">
          		<div class="panel panel-danger">
            		<div class="panel-heading">
              			<h3 class="panel-title">Prochains évènements :</h3>
            		</div>
            		<div class="panel-body">
              			<p>bla<br>bla<br>bla</p>
            		</div>
          		</div>
				</div>
	  		</div>
      
      		
        
      		<hr>

			<%-- Footer --%>

      		<footer>
       			<p>&copy; 2013 Vincent RAVENEAU, Coraline MARIE, Quentin MORICEAU - M1 ALMA <a href="http://www.univ-nantes.fr/">Université de Nantes</a></p>
      		</footer>

    	</div><!--/.fluid-container-->
    	
    	<%-- PopUp d'ajout d'évènement --%>
      		
        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    		<div class="modal-dialog">
      		<div class="modal-content">
        		<div class="modal-header">
          			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
          			<h4 class="modal-title">Ajout d'un évènement :</h4>
        		</div>
        		<div class="modal-body">
            		<form>
						<div class="col-lg-6">
                    	<input class="form-control" id="sport" type="text" placeholder="Sport">
						</div>
						<div class="col-lg-6">
                    	<input class="form-control" id="lieu" type="text" placeholder="Lieu">
						</div><br><br>
						<div class="col-lg-6">
                    	<input class="form-control" id="date" type="text" placeholder="Date">
						</div>
						<div class="col-lg-6">
                    	<input class="form-control" type="text" placeholder="Nombre de place">
						</div><br><br>
						<textarea class="form-control" rows="3">Descriptif</textarea>
            		</form>
        		</div>
        		<div class="modal-footer">
          			<button type="button" class="btn btn-danger" data-dismiss="modal">Annuler</button>
          			<button type="button" class="btn btn-primary">Ajouter !</button>
        		</div>
      		</div><!-- /.modal-content -->
    		</div><!-- /.modal-dialog -->
  		</div><!-- /.modal -->

    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="bootstrap/js/jquery.js"></script>
    <script src="bootstrap/js/bootstrap.js"></script>
	<script src="bootstrap/js/bootstrap-datepicker.js"></script>
	<script src="bootstrap/js/typeahead.js"></script>
    <script>
        $("#movin").css("color", "orange");
        $("#nantes").css("color", "green");
        $(".btn").css("color", "white");
		$(".btn-nav").css("margin-top", "9px");
        $("#logo").css("height", "40px");
		$('#date').datepicker({
          format: "dd/mm/yyyy",
          startDate: "today",
          language: "fr",
          orientation: "top left",
          calendarWeeks: true
        });
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