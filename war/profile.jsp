<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="classes.UserClass" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:useBean id="users" scope="application" class="beans.UsersBean" />
<jsp:useBean id="currentUser" scope="session" class="beans.UserBean" />

<%-- Checking if the user is logged in or not --%>		
<%
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	if (user != null) {
		boolean userDeletion = false;
		// Deleting the user's profile and logging him out if needed
		if (request.getParameter("suppression") != null && request.getParameter("suppression").equals("true")) {
			users.removeUser(new UserClass(user.getEmail()));
			response.sendRedirect(userService.createLogoutURL("/index.jsp"));
			userDeletion = true;
		}
		// Adding the user to the users' list, and putting him in the session bean (if necessary)
		if (!userDeletion) {
			pageContext.setAttribute("user", user);
		    users.addUser(new UserClass(user.getEmail()));
		    users.getUser(user.getEmail()).setName(request.getParameter("nomUtilisateur"));
		    currentUser.setUser(users.getUser(user.getEmail()), user.getEmail());
		}
		// Handling the sport given in parameter
		// Adding it to the user's favorites if it already isn't
		if (request.getParameter("addSport") != null && !request.getParameter("addSport").isEmpty())
			currentUser.addSport(request.getParameter("addSport"));
		// Removing it from the user's favorites if it already is into
		if (request.getParameter("removeSport") != null)
			currentUser.removeSport(request.getParameter("removeSport"));
		// Handling the place given in parameter
		// Adding it to the user's favorites if it already isn't
		if (request.getParameter("addPlace") != null && !request.getParameter("addPlace").isEmpty())
			currentUser.addPlace(request.getParameter("addPlace"));
		// Removing it from the user's favorites if it already is into
		if (request.getParameter("removePlace") != null)
			currentUser.removePlace(request.getParameter("removePlace"));
	} else {	// Go back to the index if the user isn't logged in
		response.sendRedirect(userService.createLogoutURL("/index.jsp"));
	}
%>

<html>
<head>
    <meta charset="utf-8">
    <title>Profil de <% out.print(currentUser.getName()); %></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Le style -->
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
          		<a class="navbar-brand" href="home.jsp"><img id="logo" alt="logo" src="bootstrap/img/LogoMN.png"><span id="movin"> Movin'</span><span id="nantes">Nantes</span></a>
        	</div>
        	<div class="navbar-collapse collapse">
          		<ul class="nav navbar-nav navbar-right">
          			<li><a href="home.jsp" class="btn btn-warning btn-nav">Accueil</a></li>
			  		<li>&nbsp;</li>
            		<li><a href="<%= userService.createLogoutURL("/index.jsp") %>" class="btn btn-danger btn-small btn-nav">Déconnexion</a></li>
          		</ul>
        	</div><!--/.nav-collapse -->
   		</div>
   	</div>
   	
	<%-- The page's content --%>
	<div class="container">
   		<legend>Profil de <%out.print(currentUser.getName());%> (<% out.print(currentUser.getMail());%>) </legend>
		<div class="row">
       		<div class="col-sm-5">
  				<form class="form-inline" method="post" action="profile.jsp">
					Pseudo affiché sur le site: 
					<div class="form-group">
			 			<label class="sr-only">Nom</label>
						<input class="form-control" name="nomUtilisateur" type="text" value="<%out.print(currentUser.getName());%>">
					</div>
					<button type="submit" class="btn btn-info">Changer</button>
				</form>
			</div>
			<div class="col-sm-3">
			
			</div>
			<div class="col-sm-4">
  				<form class="form-inline" method="post" action="profile.jsp">
  					Se désinscrire du site:
  					<input type="hidden" name="suppression" value="true"/>
					<button type="submit" class="btn btn-danger">Supprimer votre profil</button>
				</form>
			</div>
		</div>
		<hr>
		<div class="row">
       		<div class="col-sm-4">
         		<div class="panel panel-info">
           			<div class="panel-heading">
             			<h3 class="panel-title">Mes lieux favoris :</h3>
           			</div>
           			<div class="panel-body">
           				<%
           					for(int i=0;i<currentUser.getNumberOfPlaces();i++) {
           				%>
           						<form class="form-inline" method="post" action="/profile.jsp">
       								<%= currentUser.getPlace(i) %>
									<input name="removePlace" type="hidden" value="<%= currentUser.getPlace(i) %>">
									<button type="submit" class="btn btn-danger flt-right">Enlever</button>
								</form>
           				<%
           					}
           				%>
		  				<form class="form-inline" method="post" action="/profile.jsp">
		  					<div class="form-group">
  								<input class="form-control" name="addPlace" id="lieu" type="text" placeholder="Lieu">
  							</div>
							<button type="submit" class="btn btn-info">Ajouter</button>
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
           				<%
           					for(int i=0;i<currentUser.getNumberOfSports();i++) {
           				%>
           						<form class="form-inline" method="post" action="/profile.jsp">
       								<%= currentUser.getSport(i) %>
									<input name="removeSport" type="hidden" value="<%= currentUser.getSport(i) %>">
									<button type="submit" class="btn btn-danger flt-right">Enlever</button>
								</form>
           				<%
           					}
           				%>
		  				<form class="form-inline" method="post" action="/profile.jsp">
		  					<div class="form-group">
  								<input class="form-control" name="addSport" id="sport" type="text" placeholder="Sport">
  							</div>
							<button type="submit" class="btn btn-success">Ajouter</button>
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
             			<p></p>
           			</div>
       			</div>
			</div>
  		</div>
		<hr>
		<%-- The site's footer --%>
	    <jsp:include page="footer.jsp"/>
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
	  		local: ['ACCROBRANCHE', 'ACCROBRANCHES', 'ACROSPORT', 'ACROSPORTS', 'AEROBIC', 'AEROBICS', 'AEROMODELISME', 'AEROMODELISMES', 'AEROSTATION', 'AEROSTATIONS', 'AGRES', 'AIKIDO', 'AIKIDOS', 'ALPINISME', 'ALPINISMES', 'AMERICAINE', 'AMERICAINES', 'ANNEAUX', 'APNEE', 'APNEES', 'AQUAGYM', 'AQUAGYMS', 'ARBALETE', 'ARBALETES', 'ATHLETISME', 'ATHLETISMES', 'ATTELAGE', 'ATTELAGES', 'AUTOCROSS', 'AUTOMOBILE', 'AUTOMOBILES', 'AVIATION', 'AVIATIONS', 'AVIRON', 'AVIRONS', 'BADMINTON', 'BADMINTONS', 'BAREFOOT', 'BAREFOOTS', 'BASEBALL', 'BASEBALLS', 'BASKET', 'BASKETBALL', 'BASKETBALLS', 'BASKETS', 'BATON', 'BATONS', 'BENJI', 'BENJIS', 'BIATHLON', 'BIATHLONS', 'BICROSS', 'BIGUINE', 'BIGUINES', 'BILLARD', 'BILLARDS', 'BOBSLEIGH', 'BOBSLEIGHS', 'BODYBOARD', 'BODYBOARDS', 'BODYBUILDING', 'BODYBUILDINGS', 'BOOMERANG', 'BOOMERANGS', 'BOSSES', 'BOULES', 'BOULISME', 'BOULISMES', 'BOUMERANG', 'BOUMERANGS', 'BOWLING', 'BOWLINGS', 'BOXE', 'BOXES', 'BRASSE', 'BRASSES', 'BRIDGE', 'BRIDGES', 'CANNE', 'CANNES', 'CANOE', 'CANOEISME', 'CANOEISMES', 'CANOES', 'CANOTAGE', 'CANOTAGES', 'CANYONING', 'CANYONINGS', 'CANYONISME', 'CANYONISMES', 'CAPOEIRA', 'CAPOEIRAS', 'CARABINE', 'CARABINES', 'CARROM', 'CARROMS', 'CATCH', 'CATCHS', 'CERCEAU', 'CESTE', 'CESTES', 'CHASSE', 'CHASSES', 'CHAUSSON', 'CHAUSSONS', 'CHISTERA', 'CHISTERAS', 'CIRCUIT', 'CIRCUITS', 'CLAQUETTES', 'COMBAT', 'COMBATS', 'COMBINE', 'COMBINES', 'COURSE', 'COURSES', 'CRAWL', 'CRAWLS', 'CRICKET', 'CRICKETS', 'CROCHE', 'CROCHES', 'CROQUET', 'CROQUETS', 'CROSS', 'CROSSE', 'CROSSES', 'CULTURISME', 'CULTURISMES', 'CURLING', 'CURLINGS', 'CYCLISME', 'CYCLISMES', 'CYCLOCROSS', 'CYCLOTOURISME', 'CYCLOTOURISMES', 'DANSE', 'DANSES', 'DECATHLON', 'DECATHLONS', 'DELTAPLANE', 'DELTAPLANES', 'DERBIES', 'DERBY', 'DERBYS', 'DERIVEUR', 'DERIVEURS', 'DESCENTE', 'DESCENTES', 'DISQUE', 'DISQUES', 'DOS', 'DRAGSTER', 'DRAGSTERS', 'DRESSAGE', 'DRESSAGES', 'DUATHLON', 'DUATHLONS', 'ECHASSE', 'ECHASSES', 'ECHECS', 'ENDURANCE', 'ENDURANCES', 'ENDURO', 'ENDUROS', 'EPEE', 'EPEES', 'EPEISME', 'EPEISMES', 'EQUITATION', 'EQUITATIONS', 'ERGOMETRE', 'ERGOMETRES', 'ESCALADE', 'ESCALADES', 'ESCRIME', 'ESCRIMES', 'FITNESS', 'FLAG', 'FLAGS', 'FLAT', 'FLATS', 'FLECHETTES', 'FLEURET', 'FLEURETS', 'FOOTBALL', 'FOOTBALLS', 'FOOTING', 'FOOTINGS', 'FREERIDE', 'FREERIDES', 'FRISBEE', 'FRISBEES', 'FUN', 'FUNBOARD', 'FUNBOARDS', 'FUNS', 'GALOP', 'GALOPS', 'GIRAVIATION', 'GIRAVIATIONS', 'GLACIAIRISME', 'GLACIAIRISMES', 'GLACIERISME', 'GLACIERISMES', 'GOLF', 'GOLFS', 'GOUREN', 'GOURENS', 'GRIMPE', 'GRIMPES', 'GYMKHANA', 'GYMNASTIQUE', 'GYMNASTIQUES', 'HAIES', 'HALTEROPHILIE', 'HALTEROPHILIES', 'HAND', 'HANDBALL', 'HANDBALLS', 'HANDISPORT', 'HANDISPORTS', 'HANDS', 'HAUTEUR', 'HAUTEURS', 'HEPTATHLON', 'HEPTATHLONS', 'HIMALAYISME', 'HIMALAYISMES', 'HIPPISME', 'HIPPISMES', 'HOCKEY', 'HOCKEYS', 'HUNTER', 'HUNTERS', 'HYDROGLISSEUR', 'HYDROGLISSEURS', 'HYDROSPEED', 'HYDROSPEEDS', 'JAVELOT', 'JAVELOTS', 'JOGGING', 'JOGGINGS', 'JOUTE', 'JOUTES', 'JUDO', 'JUDOS', 'JUJITSU', 'JUJITSUS', 'JUMPING', 'JUMPINGS', 'KARATE', 'KARATES', 'KARTING', 'KARTINGS', 'KAYAC', 'KAYACS', 'KAYAK', 'KAYAKS', 'KEIRIN', 'KEIRINS', 'KENDO', 'KENDOS', 'KILOMETRE', 'KILOMETRES', 'KITESURF', 'KITESURFS', 'KYUDO', 'KYUDOS', 'LAMB', 'LAMBADA', 'LAMBADAS', 'LAMBS', 'LANCER', 'LANCERS', 'LONGUE', 'LONGUES', 'LONGUEUR', 'LONGUEURS', 'LUGE', 'LUGES', 'LUTTE', 'LUTTES', 'MADISON', 'MADISONS', 'MAJORETTES', 'MARATHON', 'MARATHONS', 'MARCHE', 'MARCHES', 'MARTEAU', 'MARTEAUX', 'MASSUES', 'MILE', 'MILES', 'MINIGOLF', 'MINIGOLFS', 'MODELISME', 'MODELISMES', 'MONOSKI', 'MONOSKIS', 'MOTOBALL', 'MOTOBALLS', 'MOTOCROSS', 'MOTOCYCLISME', 'MOTOCYCLISMES', 'MOTONAUTISME', 'MOTONAUTISMES', 'MOTONEIGE', 'MOTONEIGES', 'MULTICOQUE', 'MULTICOQUES', 'MUSCULATION', 'MUSCULATIONS', 'NATATION', 'NATATIONS', 'NAUTISME', 'NAUTISMES', 'NAVIGATION', 'NAVIGATIONS', 'NUNCHAKU', 'NUNCHAKUS', 'OBSTACLE', 'OBSTACLES', 'OFFSHORE', 'OFFSHORES', 'OMNIUM', 'OMNIUMS', 'PAINTBALL', 'PAINTBALLS', 'PALA', 'PALAS', 'PALET', 'PALETA', 'PALETAS', 'PALETS', 'PANACHE', 'PANACHES', 'PANCRACE', 'PANCRACES', 'PAPILLON', 'PAPILLONS', 'PARACHUTISME', 'PARACHUTISMES', 'PARAPENTE', 'PARAPENTES', 'PATINAGE', 'PATINAGES', 'PAUME', 'PAUMES', 'PECHE', 'PECHES', 'PELOTE', 'PELOTES', 'PENTATHLON', 'PENTATHLONS', 'PERCHE', 'PERCHES', 'PETANQUE', 'PETANQUES', 'PILATES', 'PIROGUE', 'PIROGUES', 'PISTAGE', 'PISTAGES', 'PISTOLET', 'PISTOLETS', 'PLANEUR', 'PLANEURS', 'PLAT', 'PLATEAUX', 'PLATS', 'PLONGEE', 'PLONGEES', 'PLONGEON', 'PLONGEONS', 'POIDS', 'POLO', 'POLOS', 'POURSUITE', 'POURSUITES', 'POUTRE', 'POUTRES', 'PUGILAT', 'PUGILATS', 'PYRENEISME', 'PYRENEISMES', 'QUAD', 'QUADS', 'QUILLES', 'RACE', 'RACES', 'RAFT', 'RAFTING', 'RAFTINGS', 'RAFTS', 'RAID', 'RAIDS', 'RALLYE', 'RALLYES', 'RAMEUR', 'RAMEURS', 'RAMPE', 'RAMPES', 'RANDONNEE', 'RANDONNEES', 'RAQUETTE', 'RAQUETTES', 'REBOT', 'REBOTS', 'REGATE', 'REGATES', 'RELAIS', 'RINGUETTE', 'RINGUETTES', 'ROCK', 'ROCKS', 'RODEO', 'RODEOS', 'ROLLER', 'ROLLERS', 'ROQUE', 'ROQUES', 'ROWING', 'ROWINGS', 'RUBAN', 'RUGBY', 'RUGBYS', 'RUMBA', 'RUMBAS', 'SABRE', 'SABRES', 'SALSA', 'SALSAS', 'SAMBA', 'SAMBAS', 'SAMBO', 'SAMBOS', 'SARBACANE', 'SARBACANES', 'SAUT', 'SAUTS', 'SAUVETAGE', 'SAUVETAGES', 'SAVATE', 'SAVATES', 'SCRATCH', 'SCRATCHS', 'SILAT', 'SIRTAKI', 'SIRTAKIS', 'SKATE', 'SKATEBOARD', 'SKATEBOARDS', 'SKATES', 'SKATING', 'SKEET', 'SKELETON', 'SKELETONS', 'SKI', 'SKIS', 'SLALOM', 'SLALOMS', 'SNOOKER', 'SNOOKERS', 'SNOWBOARD', 'SNOWBOARDS', 'SOCCER', 'SOCCERS', 'SOFTBALL', 'SOFTBALLS', 'SOL', 'SOLING', 'SOLINGS', 'SOLS', 'SOULE', 'SOULES', 'SPEEDWAY', 'SPEEDWAYS', 'SPELEOLOGIE', 'SPELEOLOGIES', 'SPRINT', 'SPRINTS', 'SQUASH', 'SQUASHS', 'STEEPLE', 'STEEPLES', 'STEP', 'STEPS', 'STIPLE', 'STIPLES', 'STRETCHING', 'STRETCHINGS', 'SUMO', 'SUMOS', 'SURF', 'SURFS', 'SWING', 'SWINGS', 'TAEKWONDO', 'TAEKWONDOS', 'TAMBOURIN', 'TAMBOURINS', 'TANDEM', 'TANDEMS', 'TANGO', 'TANGOS', 'TENNIS', 'TIR', 'TIRS', 'TORBALL', 'TORBALLS', 'TOURNOI', 'TOURNOIS', 'TRAIL', 'TRAILS', 'TRAINEAU', 'TRAINEAUX', 'TRAMPOLINE', 'TRAMPOLINES', 'TRANSAT', 'TRANSATS', 'TREKKING', 'TREKKINGS', 'TRIAL', 'TRIALS', 'TRIATHLON', 'TRIATHLONS', 'TRINQUET', 'TRINQUETS', 'TROT', 'TROTS', 'TUBING', 'TUBINGS', 'TUMBLING', 'TUMBLINGS', 'VALSE', 'VALSES', 'VARAPPE', 'VARAPPES', 'VELOCROSS', 'VITESSE', 'VITESSES', 'VOILE', 'VOILES', 'VOLLEY', 'VOLTIGE', 'VOLTIGES', 'WAKEBOARD', 'WAKEBOARDS', 'WINDSURF', 'WINDSURFS', 'WUSHU', 'WUSHUS', 'YACHTING', 'YACHTINGS', 'YOGA', 'YOGAS']
		});
		$('#lieu').typeahead({
	  		name: 'lieus',
	  		local: ['The moon', 'La petite amazonie', 'Tour de Bretagne']
		});
   	</script>

</body>
</html>
