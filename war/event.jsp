<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
       			<ul class="nav navbar-nav navbar-right">
         			<li><a href="profile.jsp" class="btn btn-warning btn-small btn-nav">Profil</a></li>
					<li>&nbsp;</li>
         			<li><a href="index.jsp" class="btn btn-danger btn-small btn-nav">Déconnexion</a></li>
       			</ul>
     		</div><!--/.nav-collapse -->
		</div>
	</div>
	
    <%-- The page's content --%>
    <div class="container">
  		<div class="row">
	        <div class="col-sm-8">
          		<div class="panel panel-primary">
		            <div class="panel-heading">
	              		<h3 class="panel-title">Evènement proposé par xxx :</h3>
		            </div>
		            <div class="panel-body">
	              		<p>Sport : Football<br>Lieu : Hippodrome<br>Date : 27/11/2013 18h00<br>Place : 7/22<br>Description : Un petit foot 11v11 bien sympas.</p>
		              	<a href="#" class="btn btn-primary">S'inscrire</a>
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
      	<footer>
        	<p>&copy; 2013 Vincent RAVENEAU, Coraline MARIE, Quentin MORICEAU - M1 ALMA <a href="http://www.univ-nantes.fr/">Université de Nantes</a></p>
      	</footer>

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
