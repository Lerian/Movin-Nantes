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
<%@ page import="classes.UserClass" %>
<%@ page import="classes.EventClass" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:useBean id="users" scope="application" class="beans.UsersBean" />
<jsp:useBean id="currentUser" scope="session" class="beans.UserBean" />
<jsp:useBean id="events" scope="application" class="beans.EventsBean"/>

<%-- Checking if the user is logged in or not --%>		
<%
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	if (user != null) {
		// Adding the user to the users' list, and putting him in the session bean (if necessary)
		pageContext.setAttribute("user", user);
	    users.addUser(new UserClass(user.getEmail()));
	    currentUser.setUser(users.getUser(user.getEmail()), user.getEmail());
	    // Creating the event given in parameter if it is relevant
	    if (request.getParameter("sport") != null &&
	    	!request.getParameter("sport").isEmpty() &&
	    	!request.getParameter("lieu").isEmpty() &&
	    	!request.getParameter("date").isEmpty() &&
	    	!request.getParameter("places").isEmpty() &&
	    	!request.getParameter("description").isEmpty())
	    {
	    	EventClass ev = new EventClass(
	    			request.getParameter("sport"),
	    			request.getParameter("lieu"),
	    			request.getParameter("places"),
	    			request.getParameter("date"),
	    			request.getParameter("description"),
	    			users.getUser(user.getEmail()));
	    	events.addEvent(ev);
	    	currentUser.addEventCreated(ev);
	    } else { // Handling the existing event given in parameter
	    	if (request.getParameter("eventID") != null) {
	    		// Leaving it if the user has already joined
	    		if (currentUser.getEventJoinedById(request.getParameter("eventID")) != null) {
	    			currentUser.removeEventJoined(currentUser.getEventJoinedById(request.getParameter("eventID")));
	    			events.getEventById(request.getParameter("eventID")).addAPlace();
	    		} else { // Joining it if the user has not already and places are available
	    			if (events.getEventById(request.getParameter("eventID")).getPlaces() > 0) {
	    				currentUser.addEventJoined(events.getEventById(request.getParameter("eventID")));
	    				events.getEventById(request.getParameter("eventID")).removeAPlace();
	    			}
	    		}
	    	}
	    }
	} else {	// Go back to the index if the user isn't logged in
		response.sendRedirect(userService.createLogoutURL("/index.jsp"));
	}
%>

<html>
<head>
	<link rel="stylesheet" type="text/css" href="style.css" />
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
	<link href="bootstrap/css/datepicker.css" rel="stylesheet">
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
         		<a class="navbar-brand" href="home.jsp"><img id="logo" alt="logo" src="bootstrap/img/LogoMN.png"><span id="movin"> Movin'</span><span id="nantes">Nantes</span></a>
       		</div>
       		<div class="navbar-collapse collapse">
         		<ul class="nav navbar-nav navbar-right">
		  			<li><a href="profile.jsp" class="btn btn-warning btn-nav">Profil</a></li>
		  			<li>&nbsp;</li>
             		<li><a href="<%= userService.createLogoutURL("/index.jsp") %>" class="btn btn-danger btn-nav">Déconnexion</a></li>
	  			</ul>
       		</div>
     	</div>
	</div>
	
	<%-- The page's content --%>
	<div class="container">
		<%	// Affichage d'un avertissement si le pseudo est celui par défaut
			if(currentUser.nameIsDefault()) {
			%>
			<div class="row">
				<p class="text-center"><a href="profile.jsp" class="btn btn-warning btn-nav">Attention! Votre pseudo est toujours le pseudo par défaut, vous devriez le changer dans votre profil !</a></p>
			</div>
			<hr>
			<%
			}
		%>
	
		<div class="row">
        	<div class="col-sm-4">
       			<div class="panel panel-info">
         			<div class="panel-heading">
           				<h3 class="panel-title">Mes évènements :</h3>
         			</div>
         			<div class="panel-body">
         				<%
         					for(int i=0;i<currentUser.getNumberOfEventsCreated();i++) {
   						%>
								<p>Activité : <% out.print(currentUser.getEventCreated(i).getSport()); %></p>
   								<p>Lieu : <% out.print(currentUser.getEventCreated(i).getLieu()); %></p>
   								<p>Date : <% out.print(currentUser.getEventCreated(i).getDateString()); %></p>
   								<p>Places restantes : <% out.print(currentUser.getEventCreated(i).getPlaces()); %></p>
   								<p><% out.print(currentUser.getEventCreated(i).getDescription()); %></p>
   								<form method="post" action="/event.jsp">
   									<input type="hidden" name="eventID" value="<%= currentUser.getEventCreated(i).hashCode() %>"/>
   									<button type="submit" class="btn btn-info">+ d'infos</button>
   								</form>
   								<hr>
   						<%
         					}
         				%>
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
         				<%
         					for(int i=0;i<currentUser.getNumberOfEventsJoined();i++) {
         						if (i > 0) {
   						%>
   									<hr>
   									<%
         						}
   									%>
								<p>Activité : <% out.print(currentUser.getEventJoined(i).getSport()); %></p>
   								<p>Lieu : <% out.print(currentUser.getEventJoined(i).getLieu()); %></p>
   								<p>Date : <% out.print(currentUser.getEventJoined(i).getDateString()); %></p>
   								<p>Places restantes : <% out.print(currentUser.getEventJoined(i).getPlaces()); %></p>
   								<p><% out.print(currentUser.getEventJoined(i).getDescription()); %></p>
   								<div class="row">
   									<div class="col-sm-4">
   										<form method="post" action="/event.jsp">
   											<input type="hidden" name="eventID" value="<%= currentUser.getEventJoined(i).hashCode() %>"/>
   											<button type="submit" class="btn btn-info">+ d'infos</button>
   										</form>
   									</div>
   									<div class="col-sm-4">
   										<form method="post" action="/home.jsp">
   											<input type="hidden" name="eventID" value="<%= currentUser.getEventJoined(i).hashCode() %>"/>
   											<button type="submit" class="btn btn-danger">Désinscription</button>
   										</form>
   									</div>
   								</div>
   						<%
         					}
         				%>
         			</div>
       			</div>
  			</div>
            <div class="col-sm-4">
         		<div class="panel panel-danger">
	           		<div class="panel-heading">
             			<h3 class="panel-title">Prochains évènements intéressants:</h3>
	           		</div>
	           		<div class="panel-body">
         				<%
         					int nbEvents = 0;
         					for(int i=0;i<events.getSize() || nbEvents == 10;i++) {
         						if ((currentUser.getEventJoinedById(String.valueOf(events.getEvent(i).hashCode())) == null)
         							&&
         							(currentUser.getEventCreatedById(String.valueOf(events.getEvent(i).hashCode())) == null)
         							&&
         							(events.getEvent(i).getPlaces() > 0))
         						{
             						if (nbEvents > 0) {
  						%>
   	   									<hr>
   	   									<%
             	         			}
         							nbEvents++;
             	   						%>
									<p>Activité : <% out.print(events.getEvent(i).getSport()); %></p>
	   								<p>Lieu : <% out.print(events.getEvent(i).getLieu()); %></p>
	   								<p>Date : <% out.print(events.getEvent(i).getDateString()); %></p>
	   								<p>Places restantes : <% out.print(events.getEvent(i).getPlaces()); %></p>
	   								<p><% out.print(events.getEvent(i).getDescription()); %></p>
	   								<div class="row">
   										<div class="col-sm-4">
   											<form method="post" action="/event.jsp">
   												<input type="hidden" name="eventID" value="<%= events.getEvent(i).hashCode() %>"/>
   												<button type="submit" class="btn btn-info">+ d'infos</button>
   											</form>
   										</div>
   										<div class="col-sm-4">
   											<form method="post" action="/home.jsp">
   												<input type="hidden" name="eventID" value="<%= events.getEvent(i).hashCode() %>"/>
   												<button type="submit" class="btn btn-success">Inscription</button>
   											</form>
   										</div>
   									</div>
   						<%
         						}
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
   	
   	<%-- PopUp d'ajout d'évènement --%>
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
  			<div class="modal-content">
	    		<div class="modal-header">
	      			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	      			<h4 class="modal-title">Ajout d'un évènement :</h4>
	    		</div>
	    		<div class="modal-body">
	        		<form method="post" action="/home.jsp">
						<div class="col-lg-6">
	                		<input class="form-control" id="sport" name ="sport" type="text" placeholder="Sport">
						</div>
						<div class="col-lg-6">
	                		<input class="form-control" id="lieu" name="lieu" type="text" placeholder="Lieu">
						</div><br><br>
						<div class="col-lg-6">
							<% //TODO gérer l'heure %>
	                		<input class="form-control" id="date" name="date" type="text" placeholder="Date">
						</div> 
						<div class="col-lg-6">
	                		<input class="form-control" name="places" type="text" placeholder="Nombre de place">
						</div><br><br>
						<textarea class="form-control" name="description" rows="3">Descriptif</textarea>
	        			<div class="modal-footer">
      						<button class="btn btn-danger" data-dismiss="modal">Annuler</button>
	      					<button type="submit" class="btn btn-primary">Ajouter !</button>
    					</div>
	        		</form>
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
         format: "dd-mm-yyyy",
         startDate: "today",
         language: "fr",
         orientation: "top left",
         calendarWeeks: true
       });
	$('#sport').typeahead({
	  name: 'sports',
	  local: ['ACCROBRANCHE', 'ACCROBRANCHES', 'ACROSPORT', 'ACROSPORTS', 'AEROBIC', 'AEROBICS', 'AEROMODELISME', 'AEROMODELISMES', 'AEROSTATION', 'AEROSTATIONS', 'AGRES', 'AIKIDO', 'AIKIDOS', 'ALPINISME', 'ALPINISMES', 'AMERICAINE', 'AMERICAINES', 'ANNEAUX', 'APNEE', 'APNEES', 'AQUAGYM', 'AQUAGYMS', 'ARBALETE', 'ARBALETES', 'ATHLETISME', 'ATHLETISMES', 'ATTELAGE', 'ATTELAGES', 'AUTOCROSS', 'AUTOMOBILE', 'AUTOMOBILES', 'AVIATION', 'AVIATIONS', 'AVIRON', 'AVIRONS', 'BADMINTON', 'BADMINTONS', 'BAREFOOT', 'BAREFOOTS', 'BASEBALL', 'BASEBALLS', 'BASKET', 'BASKETBALL', 'BASKETBALLS', 'BASKETS', 'BATON', 'BATONS', 'BENJI', 'BENJIS', 'BIATHLON', 'BIATHLONS', 'BICROSS', 'BIGUINE', 'BIGUINES', 'BILLARD', 'BILLARDS', 'BOBSLEIGH', 'BOBSLEIGHS', 'BODYBOARD', 'BODYBOARDS', 'BODYBUILDING', 'BODYBUILDINGS', 'BOOMERANG', 'BOOMERANGS', 'BOSSES', 'BOULES', 'BOULISME', 'BOULISMES', 'BOUMERANG', 'BOUMERANGS', 'BOWLING', 'BOWLINGS', 'BOXE', 'BOXES', 'BRASSE', 'BRASSES', 'BRIDGE', 'BRIDGES', 'CANNE', 'CANNES', 'CANOE', 'CANOEISME', 'CANOEISMES', 'CANOES', 'CANOTAGE', 'CANOTAGES', 'CANYONING', 'CANYONINGS', 'CANYONISME', 'CANYONISMES', 'CAPOEIRA', 'CAPOEIRAS', 'CARABINE', 'CARABINES', 'CARROM', 'CARROMS', 'CATCH', 'CATCHS', 'CERCEAU', 'CESTE', 'CESTES', 'CHASSE', 'CHASSES', 'CHAUSSON', 'CHAUSSONS', 'CHISTERA', 'CHISTERAS', 'CIRCUIT', 'CIRCUITS', 'CLAQUETTES', 'COMBAT', 'COMBATS', 'COMBINE', 'COMBINES', 'COURSE', 'COURSES', 'CRAWL', 'CRAWLS', 'CRICKET', 'CRICKETS', 'CROCHE', 'CROCHES', 'CROQUET', 'CROQUETS', 'CROSS', 'CROSSE', 'CROSSES', 'CULTURISME', 'CULTURISMES', 'CURLING', 'CURLINGS', 'CYCLISME', 'CYCLISMES', 'CYCLOCROSS', 'CYCLOTOURISME', 'CYCLOTOURISMES', 'DANSE', 'DANSES', 'DECATHLON', 'DECATHLONS', 'DELTAPLANE', 'DELTAPLANES', 'DERBIES', 'DERBY', 'DERBYS', 'DERIVEUR', 'DERIVEURS', 'DESCENTE', 'DESCENTES', 'DISQUE', 'DISQUES', 'DOS', 'DRAGSTER', 'DRAGSTERS', 'DRESSAGE', 'DRESSAGES', 'DUATHLON', 'DUATHLONS', 'ECHASSE', 'ECHASSES', 'ECHECS', 'ENDURANCE', 'ENDURANCES', 'ENDURO', 'ENDUROS', 'EPEE', 'EPEES', 'EPEISME', 'EPEISMES', 'EQUITATION', 'EQUITATIONS', 'ERGOMETRE', 'ERGOMETRES', 'ESCALADE', 'ESCALADES', 'ESCRIME', 'ESCRIMES', 'FITNESS', 'FLAG', 'FLAGS', 'FLAT', 'FLATS', 'FLECHETTES', 'FLEURET', 'FLEURETS', 'FOOTBALL', 'FOOTBALLS', 'FOOTING', 'FOOTINGS', 'FREERIDE', 'FREERIDES', 'FRISBEE', 'FRISBEES', 'FUN', 'FUNBOARD', 'FUNBOARDS', 'FUNS', 'GALOP', 'GALOPS', 'GIRAVIATION', 'GIRAVIATIONS', 'GLACIAIRISME', 'GLACIAIRISMES', 'GLACIERISME', 'GLACIERISMES', 'GOLF', 'GOLFS', 'GOUREN', 'GOURENS', 'GRIMPE', 'GRIMPES', 'GYMKHANA', 'GYMNASTIQUE', 'GYMNASTIQUES', 'HAIES', 'HALTEROPHILIE', 'HALTEROPHILIES', 'HAND', 'HANDBALL', 'HANDBALLS', 'HANDISPORT', 'HANDISPORTS', 'HANDS', 'HAUTEUR', 'HAUTEURS', 'HEPTATHLON', 'HEPTATHLONS', 'HIMALAYISME', 'HIMALAYISMES', 'HIPPISME', 'HIPPISMES', 'HOCKEY', 'HOCKEYS', 'HUNTER', 'HUNTERS', 'HYDROGLISSEUR', 'HYDROGLISSEURS', 'HYDROSPEED', 'HYDROSPEEDS', 'JAVELOT', 'JAVELOTS', 'JOGGING', 'JOGGINGS', 'JOUTE', 'JOUTES', 'JUDO', 'JUDOS', 'JUJITSU', 'JUJITSUS', 'JUMPING', 'JUMPINGS', 'KARATE', 'KARATES', 'KARTING', 'KARTINGS', 'KAYAC', 'KAYACS', 'KAYAK', 'KAYAKS', 'KEIRIN', 'KEIRINS', 'KENDO', 'KENDOS', 'KILOMETRE', 'KILOMETRES', 'KITESURF', 'KITESURFS', 'KYUDO', 'KYUDOS', 'LAMB', 'LAMBADA', 'LAMBADAS', 'LAMBS', 'LANCER', 'LANCERS', 'LONGUE', 'LONGUES', 'LONGUEUR', 'LONGUEURS', 'LUGE', 'LUGES', 'LUTTE', 'LUTTES', 'MADISON', 'MADISONS', 'MAJORETTES', 'MARATHON', 'MARATHONS', 'MARCHE', 'MARCHES', 'MARTEAU', 'MARTEAUX', 'MASSUES', 'MILE', 'MILES', 'MINIGOLF', 'MINIGOLFS', 'MODELISME', 'MODELISMES', 'MONOSKI', 'MONOSKIS', 'MOTOBALL', 'MOTOBALLS', 'MOTOCROSS', 'MOTOCYCLISME', 'MOTOCYCLISMES', 'MOTONAUTISME', 'MOTONAUTISMES', 'MOTONEIGE', 'MOTONEIGES', 'MULTICOQUE', 'MULTICOQUES', 'MUSCULATION', 'MUSCULATIONS', 'NATATION', 'NATATIONS', 'NAUTISME', 'NAUTISMES', 'NAVIGATION', 'NAVIGATIONS', 'NUNCHAKU', 'NUNCHAKUS', 'OBSTACLE', 'OBSTACLES', 'OFFSHORE', 'OFFSHORES', 'OMNIUM', 'OMNIUMS', 'PAINTBALL', 'PAINTBALLS', 'PALA', 'PALAS', 'PALET', 'PALETA', 'PALETAS', 'PALETS', 'PANACHE', 'PANACHES', 'PANCRACE', 'PANCRACES', 'PAPILLON', 'PAPILLONS', 'PARACHUTISME', 'PARACHUTISMES', 'PARAPENTE', 'PARAPENTES', 'PATINAGE', 'PATINAGES', 'PAUME', 'PAUMES', 'PECHE', 'PECHES', 'PELOTE', 'PELOTES', 'PENTATHLON', 'PENTATHLONS', 'PERCHE', 'PERCHES', 'PETANQUE', 'PETANQUES', 'PILATES', 'PIROGUE', 'PIROGUES', 'PISTAGE', 'PISTAGES', 'PISTOLET', 'PISTOLETS', 'PLANEUR', 'PLANEURS', 'PLAT', 'PLATEAUX', 'PLATS', 'PLONGEE', 'PLONGEES', 'PLONGEON', 'PLONGEONS', 'POIDS', 'POLO', 'POLOS', 'POURSUITE', 'POURSUITES', 'POUTRE', 'POUTRES', 'PUGILAT', 'PUGILATS', 'PYRENEISME', 'PYRENEISMES', 'QUAD', 'QUADS', 'QUILLES', 'RACE', 'RACES', 'RAFT', 'RAFTING', 'RAFTINGS', 'RAFTS', 'RAID', 'RAIDS', 'RALLYE', 'RALLYES', 'RAMEUR', 'RAMEURS', 'RAMPE', 'RAMPES', 'RANDONNEE', 'RANDONNEES', 'RAQUETTE', 'RAQUETTES', 'REBOT', 'REBOTS', 'REGATE', 'REGATES', 'RELAIS', 'RINGUETTE', 'RINGUETTES', 'ROCK', 'ROCKS', 'RODEO', 'RODEOS', 'ROLLER', 'ROLLERS', 'ROQUE', 'ROQUES', 'ROWING', 'ROWINGS', 'RUBAN', 'RUGBY', 'RUGBYS', 'RUMBA', 'RUMBAS', 'SABRE', 'SABRES', 'SALSA', 'SALSAS', 'SAMBA', 'SAMBAS', 'SAMBO', 'SAMBOS', 'SARBACANE', 'SARBACANES', 'SAUT', 'SAUTS', 'SAUVETAGE', 'SAUVETAGES', 'SAVATE', 'SAVATES', 'SCRATCH', 'SCRATCHS', 'SILAT', 'SIRTAKI', 'SIRTAKIS', 'SKATE', 'SKATEBOARD', 'SKATEBOARDS', 'SKATES', 'SKATING', 'SKEET', 'SKELETON', 'SKELETONS', 'SKI', 'SKIS', 'SLALOM', 'SLALOMS', 'SNOOKER', 'SNOOKERS', 'SNOWBOARD', 'SNOWBOARDS', 'SOCCER', 'SOCCERS', 'SOFTBALL', 'SOFTBALLS', 'SOL', 'SOLING', 'SOLINGS', 'SOLS', 'SOULE', 'SOULES', 'SPEEDWAY', 'SPEEDWAYS', 'SPELEOLOGIE', 'SPELEOLOGIES', 'SPRINT', 'SPRINTS', 'SQUASH', 'SQUASHS', 'STEEPLE', 'STEEPLES', 'STEP', 'STEPS', 'STIPLE', 'STIPLES', 'STRETCHING', 'STRETCHINGS', 'SUMO', 'SUMOS', 'SURF', 'SURFS', 'SWING', 'SWINGS', 'TAEKWONDO', 'TAEKWONDOS', 'TAMBOURIN', 'TAMBOURINS', 'TANDEM', 'TANDEMS', 'TANGO', 'TANGOS', 'TENNIS', 'TIR', 'TIRS', 'TORBALL', 'TORBALLS', 'TOURNOI', 'TOURNOIS', 'TRAIL', 'TRAILS', 'TRAINEAU', 'TRAINEAUX', 'TRAMPOLINE', 'TRAMPOLINES', 'TRANSAT', 'TRANSATS', 'TREKKING', 'TREKKINGS', 'TRIAL', 'TRIALS', 'TRIATHLON', 'TRIATHLONS', 'TRINQUET', 'TRINQUETS', 'TROT', 'TROTS', 'TUBING', 'TUBINGS', 'TUMBLING', 'TUMBLINGS', 'VALSE', 'VALSES', 'VARAPPE', 'VARAPPES', 'VELOCROSS', 'VITESSE', 'VITESSES', 'VOILE', 'VOILES', 'VOLLEY', 'VOLTIGE', 'VOLTIGES', 'WAKEBOARD', 'WAKEBOARDS', 'WINDSURF', 'WINDSURFS', 'WUSHU', 'WUSHUS', 'YACHTING', 'YACHTINGS', 'YOGA', 'YOGAS']
	});
	$('#lieu').typeahead({
	  name: 'lieux',
	  local: ['The moon', 'La petite amazonie', 'Tour de Bretagne']
	});
   </script>
	
</body>
</html>
