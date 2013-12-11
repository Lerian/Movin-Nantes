<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<jsp:useBean id="events" scope="application" class="beans.EventsBean"/>

<html>
<head>
	<meta charset="utf-8">
    <title>Movin'Nantes</title>
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
          		<a class="navbar-brand" href="index.jsp"><img id="logo" alt="logo" src="bootstrap/img/LogoMN.png"><span id="movin"> Movin'</span><span id="nantes">Nantes</span></a>
        	</div>
      	</div>
    </div>

	<%-- The page's content --%>
	<div class="container">
      	<div class="row">
	        <div class="col-sm-8">
	          	<div class="starter-template">
				    <div class="page-header">
		            	<h2>Bienvenue sur Movin'Nantes</h2>
					</div>
		            <p class="lead">Envie de bouger ? <br>Faire un Foot, ou un Basket, mais vous n’êtes pas assez nombreux ? <br><br>Movin-Nantes vous indique en temps réel les évènements sportifs, à côté de chez vous et le nombre de place restantes. Organisez vous même vos rencontres, vos évènements et bougez !</p>
		            <p><a href="<%= UserServiceFactory.getUserService().createLoginURL("/home.jsp") %>" class="btn btn-success btn-nav">Connexion</a></p>
	          	</div>
	        </div>
	        <div class="col-sm-4">
			  	<div class="panel panel-primary">
		            <div class="panel-heading">
		              	<h3 class="panel-title">Evènements</h3>
		            </div>
		            <div class="panel-body">
         				<%
         					int nbEvents = 0;
         					for(int i=0;i<events.getSize() || nbEvents == 10;i++) {
             						if (nbEvents > 0) {
  						%>
   	   									<hr>
   	   									<%
             	         			}
         							nbEvents++;
             	   						%>
									<p><span class="label label-default">Activité</span> : <% out.print(events.getEvent(i).getSport()); %></p>
	   								<p><span class="label label-success">Lieu</span> : <% out.print(events.getEvent(i).getLieu()); %></p>
	   								<p><span class="label label-info">Date</span> : <% out.print(events.getEvent(i).getDateString()); %></p>
	   								<p><span class="label label-warning">Places restantes</span> : <% out.print(events.getEvent(i).getPlaces()); %></p>
	   								<div class="panel panel-default"><div class="panel-body"><% out.print(events.getEvent(i).getDescription()); %></div></div>
	   								<div class="row">
   										<div class="col-sm-4">
   											<form method="post" action="/event.jsp">
   												<input type="hidden" name="eventID" value="<%= events.getEvent(i).hashCode() %>"/>
   												<button type="submit" class="btn btn-info">+ d'infos</button>
   											</form>
   										</div>
   									</div>
   						<%
         					}
         					if (events.getSize() == 0) {
         				%>
         						<p>Aucun événement n'a encore été créé. Connectez-vous et soyez le premier à proposer une activité aux autres utilisateurs!</p>
         						<%
         					}
         						%>
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
		$("#logo").css("height", "40px");
    </script>

</body>
</html>
