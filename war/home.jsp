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
			 	userEntity.setProperty("places","");
			 	userEntity.setProperty("sports","");
			    
			    datastore.put(userEntity); //save it
			}
		} else {
			response.sendRedirect(userService.createLogoutURL("/index.jsp"));
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
              				<p>Allez sur la page de l'événement pour vous y inscrire</p>
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
              			<p><a href="event.jsp">Football</a></p>
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
		  local: ['ACCROBRANCHE', 'ACCROBRANCHES', 'ACROSPORT', 'ACROSPORTS', 'AEROBIC', 'AEROBICS', 'AEROMODELISME', 'AEROMODELISMES', 'AEROSTATION', 'AEROSTATIONS', 'AGRES', 'AIKIDO', 'AIKIDOS', 'ALPINISME', 'ALPINISMES', 'AMERICAINE', 'AMERICAINES', 'ANNEAUX', 'APNEE', 'APNEES', 'AQUAGYM', 'AQUAGYMS', 'ARBALETE', 'ARBALETES', 'ATHLETISME', 'ATHLETISMES', 'ATTELAGE', 'ATTELAGES', 'AUTOCROSS', 'AUTOMOBILE', 'AUTOMOBILES', 'AVIATION', 'AVIATIONS', 'AVIRON', 'AVIRONS', 'BADMINTON', 'BADMINTONS', 'BAREFOOT', 'BAREFOOTS', 'BASEBALL', 'BASEBALLS', 'BASKET', 'BASKETBALL', 'BASKETBALLS', 'BASKETS', 'BATON', 'BATONS', 'BENJI', 'BENJIS', 'BIATHLON', 'BIATHLONS', 'BICROSS', 'BIGUINE', 'BIGUINES', 'BILLARD', 'BILLARDS', 'BOBSLEIGH', 'BOBSLEIGHS', 'BODYBOARD', 'BODYBOARDS', 'BODYBUILDING', 'BODYBUILDINGS', 'BOOMERANG', 'BOOMERANGS', 'BOSSES', 'BOULES', 'BOULISME', 'BOULISMES', 'BOUMERANG', 'BOUMERANGS', 'BOWLING', 'BOWLINGS', 'BOXE', 'BOXES', 'BRASSE', 'BRASSES', 'BRIDGE', 'BRIDGES', 'CANNE', 'CANNES', 'CANOE', 'CANOEISME', 'CANOEISMES', 'CANOES', 'CANOTAGE', 'CANOTAGES', 'CANYONING', 'CANYONINGS', 'CANYONISME', 'CANYONISMES', 'CAPOEIRA', 'CAPOEIRAS', 'CARABINE', 'CARABINES', 'CARROM', 'CARROMS', 'CATCH', 'CATCHS', 'CERCEAU', 'CESTE', 'CESTES', 'CHASSE', 'CHASSES', 'CHAUSSON', 'CHAUSSONS', 'CHISTERA', 'CHISTERAS', 'CIRCUIT', 'CIRCUITS', 'CLAQUETTES', 'COMBAT', 'COMBATS', 'COMBINE', 'COMBINES', 'COURSE', 'COURSES', 'CRAWL', 'CRAWLS', 'CRICKET', 'CRICKETS', 'CROCHE', 'CROCHES', 'CROQUET', 'CROQUETS', 'CROSS', 'CROSSE', 'CROSSES', 'CULTURISME', 'CULTURISMES', 'CURLING', 'CURLINGS', 'CYCLISME', 'CYCLISMES', 'CYCLOCROSS', 'CYCLOTOURISME', 'CYCLOTOURISMES', 'DANSE', 'DANSES', 'DECATHLON', 'DECATHLONS', 'DELTAPLANE', 'DELTAPLANES', 'DERBIES', 'DERBY', 'DERBYS', 'DERIVEUR', 'DERIVEURS', 'DESCENTE', 'DESCENTES', 'DISQUE', 'DISQUES', 'DOS', 'DRAGSTER', 'DRAGSTERS', 'DRESSAGE', 'DRESSAGES', 'DUATHLON', 'DUATHLONS', 'ECHASSE', 'ECHASSES', 'ECHECS', 'ENDURANCE', 'ENDURANCES', 'ENDURO', 'ENDUROS', 'EPEE', 'EPEES', 'EPEISME', 'EPEISMES', 'EQUITATION', 'EQUITATIONS', 'ERGOMETRE', 'ERGOMETRES', 'ESCALADE', 'ESCALADES', 'ESCRIME', 'ESCRIMES', 'FITNESS', 'FLAG', 'FLAGS', 'FLAT', 'FLATS', 'FLECHETTES', 'FLEURET', 'FLEURETS', 'FOOTBALL', 'FOOTBALLS', 'FOOTING', 'FOOTINGS', 'FREERIDE', 'FREERIDES', 'FRISBEE', 'FRISBEES', 'FUN', 'FUNBOARD', 'FUNBOARDS', 'FUNS', 'GALOP', 'GALOPS', 'GIRAVIATION', 'GIRAVIATIONS', 'GLACIAIRISME', 'GLACIAIRISMES', 'GLACIERISME', 'GLACIERISMES', 'GOLF', 'GOLFS', 'GOUREN', 'GOURENS', 'GRIMPE', 'GRIMPES', 'GYMKHANA', 'GYMNASTIQUE', 'GYMNASTIQUES', 'HAIES', 'HALTEROPHILIE', 'HALTEROPHILIES', 'HAND', 'HANDBALL', 'HANDBALLS', 'HANDISPORT', 'HANDISPORTS', 'HANDS', 'HAUTEUR', 'HAUTEURS', 'HEPTATHLON', 'HEPTATHLONS', 'HIMALAYISME', 'HIMALAYISMES', 'HIPPISME', 'HIPPISMES', 'HOCKEY', 'HOCKEYS', 'HUNTER', 'HUNTERS', 'HYDROGLISSEUR', 'HYDROGLISSEURS', 'HYDROSPEED', 'HYDROSPEEDS', 'JAVELOT', 'JAVELOTS', 'JOGGING', 'JOGGINGS', 'JOUTE', 'JOUTES', 'JUDO', 'JUDOS', 'JUJITSU', 'JUJITSUS', 'JUMPING', 'JUMPINGS', 'KARATE', 'KARATES', 'KARTING', 'KARTINGS', 'KAYAC', 'KAYACS', 'KAYAK', 'KAYAKS', 'KEIRIN', 'KEIRINS', 'KENDO', 'KENDOS', 'KILOMETRE', 'KILOMETRES', 'KITESURF', 'KITESURFS', 'KYUDO', 'KYUDOS', 'LAMB', 'LAMBADA', 'LAMBADAS', 'LAMBS', 'LANCER', 'LANCERS', 'LONGUE', 'LONGUES', 'LONGUEUR', 'LONGUEURS', 'LUGE', 'LUGES', 'LUTTE', 'LUTTES', 'MADISON', 'MADISONS', 'MAJORETTES', 'MARATHON', 'MARATHONS', 'MARCHE', 'MARCHES', 'MARTEAU', 'MARTEAUX', 'MASSUES', 'MILE', 'MILES', 'MINIGOLF', 'MINIGOLFS', 'MODELISME', 'MODELISMES', 'MONOSKI', 'MONOSKIS', 'MOTOBALL', 'MOTOBALLS', 'MOTOCROSS', 'MOTOCYCLISME', 'MOTOCYCLISMES', 'MOTONAUTISME', 'MOTONAUTISMES', 'MOTONEIGE', 'MOTONEIGES', 'MULTICOQUE', 'MULTICOQUES', 'MUSCULATION', 'MUSCULATIONS', 'NATATION', 'NATATIONS', 'NAUTISME', 'NAUTISMES', 'NAVIGATION', 'NAVIGATIONS', 'NUNCHAKU', 'NUNCHAKUS', 'OBSTACLE', 'OBSTACLES', 'OFFSHORE', 'OFFSHORES', 'OMNIUM', 'OMNIUMS', 'PAINTBALL', 'PAINTBALLS', 'PALA', 'PALAS', 'PALET', 'PALETA', 'PALETAS', 'PALETS', 'PANACHE', 'PANACHES', 'PANCRACE', 'PANCRACES', 'PAPILLON', 'PAPILLONS', 'PARACHUTISME', 'PARACHUTISMES', 'PARAPENTE', 'PARAPENTES', 'PATINAGE', 'PATINAGES', 'PAUME', 'PAUMES', 'PECHE', 'PECHES', 'PELOTE', 'PELOTES', 'PENTATHLON', 'PENTATHLONS', 'PERCHE', 'PERCHES', 'PETANQUE', 'PETANQUES', 'PILATES', 'PIROGUE', 'PIROGUES', 'PISTAGE', 'PISTAGES', 'PISTOLET', 'PISTOLETS', 'PLANEUR', 'PLANEURS', 'PLAT', 'PLATEAUX', 'PLATS', 'PLONGEE', 'PLONGEES', 'PLONGEON', 'PLONGEONS', 'POIDS', 'POLO', 'POLOS', 'POURSUITE', 'POURSUITES', 'POUTRE', 'POUTRES', 'PUGILAT', 'PUGILATS', 'PYRENEISME', 'PYRENEISMES', 'QUAD', 'QUADS', 'QUILLES', 'RACE', 'RACES', 'RAFT', 'RAFTING', 'RAFTINGS', 'RAFTS', 'RAID', 'RAIDS', 'RALLYE', 'RALLYES', 'RAMEUR', 'RAMEURS', 'RAMPE', 'RAMPES', 'RANDONNEE', 'RANDONNEES', 'RAQUETTE', 'RAQUETTES', 'REBOT', 'REBOTS', 'REGATE', 'REGATES', 'RELAIS', 'RINGUETTE', 'RINGUETTES', 'ROCK', 'ROCKS', 'RODEO', 'RODEOS', 'ROLLER', 'ROLLERS', 'ROQUE', 'ROQUES', 'ROWING', 'ROWINGS', 'RUBAN', 'RUGBY', 'RUGBYS', 'RUMBA', 'RUMBAS', 'SABRE', 'SABRES', 'SALSA', 'SALSAS', 'SAMBA', 'SAMBAS', 'SAMBO', 'SAMBOS', 'SARBACANE', 'SARBACANES', 'SAUT', 'SAUTS', 'SAUVETAGE', 'SAUVETAGES', 'SAVATE', 'SAVATES', 'SCRATCH', 'SCRATCHS', 'SILAT', 'SIRTAKI', 'SIRTAKIS', 'SKATE', 'SKATEBOARD', 'SKATEBOARDS', 'SKATES', 'SKATING', 'SKEET', 'SKELETON', 'SKELETONS', 'SKI', 'SKIS', 'SLALOM', 'SLALOMS', 'SNOOKER', 'SNOOKERS', 'SNOWBOARD', 'SNOWBOARDS', 'SOCCER', 'SOCCERS', 'SOFTBALL', 'SOFTBALLS', 'SOL', 'SOLING', 'SOLINGS', 'SOLS', 'SOULE', 'SOULES', 'SPEEDWAY', 'SPEEDWAYS', 'SPELEOLOGIE', 'SPELEOLOGIES', 'SPRINT', 'SPRINTS', 'SQUASH', 'SQUASHS', 'STEEPLE', 'STEEPLES', 'STEP', 'STEPS', 'STIPLE', 'STIPLES', 'STRETCHING', 'STRETCHINGS', 'SUMO', 'SUMOS', 'SURF', 'SURFS', 'SWING', 'SWINGS', 'TAEKWONDO', 'TAEKWONDOS', 'TAMBOURIN', 'TAMBOURINS', 'TANDEM', 'TANDEMS', 'TANGO', 'TANGOS', 'TENNIS', 'TIR', 'TIRS', 'TORBALL', 'TORBALLS', 'TOURNOI', 'TOURNOIS', 'TRAIL', 'TRAILS', 'TRAINEAU', 'TRAINEAUX', 'TRAMPOLINE', 'TRAMPOLINES', 'TRANSAT', 'TRANSATS', 'TREKKING', 'TREKKINGS', 'TRIAL', 'TRIALS', 'TRIATHLON', 'TRIATHLONS', 'TRINQUET', 'TRINQUETS', 'TROT', 'TROTS', 'TUBING', 'TUBINGS', 'TUMBLING', 'TUMBLINGS', 'VALSE', 'VALSES', 'VARAPPE', 'VARAPPES', 'VELOCROSS', 'VITESSE', 'VITESSES', 'VOILE', 'VOILES', 'VOLLEY', 'VOLTIGE', 'VOLTIGES', 'WAKEBOARD', 'WAKEBOARDS', 'WINDSURF', 'WINDSURFS', 'WUSHU', 'WUSHUS', 'YACHTING', 'YACHTINGS', 'YOGA', 'YOGAS']
		});
		$('#lieu').typeahead({
		  name: 'lieus',
		  local: ['The moon', 'La petite amazonie', 'Tour de Bretagne']
		});
    </script>
		
	</body>
</html>
