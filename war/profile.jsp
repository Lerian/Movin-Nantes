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
									<button type="submit" class="btn btn-danger btn-xs flt-right">x</button>
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
									<button type="submit" class="btn btn-danger btn-xs flt-right">x</button>
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
	  		local: ["Accrobranche","Aerobic sportive","Aéromodélisme","Aérostation","Agility","Aikido","Alpinisme","Apnée","Aqua gym","Arts martiaux artistiques","Athlétisme","Aviation","Aviron","Baby foot","Badminton","Ball trap","Ballet sur glace","Baseball","Basket ball","Baton défense","Beach soccer","Beach volley","Bébé nageur","Biathlon","Billard","BMX","Bodyboard","Boogie Woogie","Boomerang","Boule lyonnaise","Bowling","Boxe américaine","Boxe anglaise","Boxe chinoise","Boxe française","Boxe thaïlandaise","Bridge","Canne de combat","Canne défense","Canoë kayak","Canyonisme","Capoeira","Carrom","Cerf volant","Chanbara","Char à voile","Cheerleading","Cirque","Claquettes","Combat libre","Combat médiéval","Course à pied","Course d'orientation","Cyclisme sur piste","Cyclisme sur route","Cyclo-cross","Cyclotourisme","Danse africaine","Danse classique","Danse contemporaine","Danse country","Danse espagnole","Danse indienne","Danse jazz","Danse modern jazz","Danse orientale","Danse sur glace","Danses caraïbes","Danses de salon","Danses latines","Danses standards","Danses swing","Deltaplane","Disc Golf","Echecs","Equitation","Escalade","Escrime","Eveil corporel","Fitness","Flag","Fléchettes","Football","Football US","Force athlétique","Futsal","Giraviation","Golf","Gouren","Grappling","Gymnastique artistique","Gymnastique douce","Gymnastique rythmique","Haltérophilie","Handball","Handisport","Hapkido","Hip hop","Hockey subaquatique","Hockey sur gazon","Hockey sur glace","Horse ball","Iaïdo","Jeet kune do","Jetski","Jiu-Jitsu brésilien","Jodo","Jorkyball","Joutes nautiques","Ju-Jitsu traditionnel","Judo","Kali Escrima","Karaté","Karting","Kempo","Kendo","Kenjutsu","Kick boxing","Kin ball","Kite surf","Kobudo","Krav maga","Kung fu","Kyudo","Luge","Luta livre","Lutte contact","Lutte gréco-romaine","Lutte libre","Marche athlétique","Modélisme","Moto cross","Moto vitesse","Motoneige","Mountainboard","Musculation","Nage avec palmes","Nage en eau vive","Naginata","Natation","Natation synchronisée","Ninjitsu","Nunchaku","Padel","Paintball","Pancrace","Parachutisme","Paramoteur","Parapente","Patinage artistique","Pêche","Pêche sous-marine","Pelote basque","Penchak Silat","Pentathlon","Pétanque","Peteca","Planche à voile","Plongée","Plongeon","Qi gong","Quad","Quilles","Qwan ki do","Rafting","Ragga","Raid nature","Rallye","Randonnée équestre","Randonnée pédestre","Raquette à neige","Rink hockey","Rock","Rock acrobatique","Roller","Roller in line hockey","ROS","Rugby à XIII","Rugby à XV","Salsa","Samba","Sambo","Sarbacana","Sarbacane","Sauvetage","Self défense","Self Pro Krav","Short track","Skateboard","Ski alpin","Ski de fond","Ski de randonnée","Ski de vitesse","Ski nautique","Ski sur herbe","Snowboard","Softball","Spéléologie","Squash","Sumo","Surf","Taekwondo","Taï chi chuan","Taï jitsu","Tambourin","Tango argentin","Tennis","Tennis de table","Thaing Bando","Tir à l'arc","Tir sportif","Tir subaquatique","Traîneaux","Trampoline","Triathlon","Tumbling","Twirling baton","ULM","Ultimate Frisbee","Viet vo dao","Voile","Vol à voile","Volley ball","VTT","Water polo","Wing chun","Yoga","Yoseikan budo"]
		});
		$('#lieu').typeahead({
			name: 'lieux',
			local: ["<b> Gymnase Emile Morice </b> [8 Quai Hoche]","<b> Gymnase Gravaud </b> [14 Rue de la Barbinais]","<b> Centre Sportif Mangin Beaulieu </b> [10 Rue Louis Joxe]","<b> Gymnase Lycée des Bourdonnières </b> [6 Rue de la Perrière]","<b> Gymnase Gobelets Ripossière </b> [24 Rue des Gobelets]","<b> Gymnase Raphaël Lebel </b> [16 Boulevard Auguste Péneau]","<b> Gymnase du Lycée Colinière </b> [129 Rue du Landreau]","<b> Gymnase Doulon </b> [1 Rue de la Basse Chénaie]","<b> Centre Sportif Croissant </b> [29 Rue du Croissant]","<b> Gymnase Malakoff IV </b> [55 Boulevard de l'Europe]","<b> Gymnase Albert Camus </b> [2 Rue du Bois de la Musse]","<b> Gymnase La Halvêque </b> [2 Rue du Moulin de la Halvêque]","<b> Gymnase Urbain Le Verrier </b> [11 Rue Urbain Le Verrier]","<b> Gymnase des Marsauderies </b> [137 Boulevard Jules Verne]","<b> Gymnase du Collège Chantenay </b> [7 Boulevard Président René Coty]","<b> Gymnase Chantenaysienne </b> [17 Rue du Quatre Septembre 1870]","<b> Gymnase Jean Zay Bellevue </b> [15B Rue Yves Kartel]","<b> Gymnase Jamet </b> [65 Route de Saint Herblain]","<b> Complexe Sportif de la Durantière </b> [70 Rue de la Durantière]","<b> Gymnase Pierre de Coubertin </b> [115 Boulevard du Massacre]","<b> Gymnase du Lycée Carcouët </b> [115 Boulevard du Massacre]","<b> Gymnase Jean Ogé </b> [10 Rue Auguste Lepère]","<b> Complexe Sportif Dervallières </b> [19 Rue Jean Marc Nattier]","<b> Gymnase Longchamp </b> [Rue Clio]","<b> Gymnase du Lycée Chauvinière </b> [22 Boulevard de la Chauvinière]","<b> Gymnase Bout des Landes </b> [3 Boulevard René Cassin]","<b> Gymnase Santos Dumont Géraudière </b> [29 Rue Santos Dumont]","<b> Gymnase Le Baut </b> [2B Rue des Renards]","<b> Gymnase Barboire </b> [49 Rue de la Bourgeonnière]","<b> Gymnase du Port Boyer </b> [73 Rue du Port Boyer]","<b> Palais des Sports Beaulieu </b> [5 Rue André Tardieu]","<b> Gymnase Malakoff III </b> [21 Rue de l'Indre]","<b> Gymnase Gaston Turpin </b> [33 Rue Gaston Turpin]","<b> Gymnase du Lycée Clemenceau </b> [1 Rue Georges Clemenceau]","<b> Gymnase du Coudray </b> [20 Rue du Coudray]","<b> Gymnase Léo Lagrange </b> [5 Rue Gaston Michel]","<b> Gymnase Joêl Paon </b> [42 Rue des Hauts Pavés]","<b> Gymnase V. Hugo </b> [29 Rue Paul Bellamy]","<b> Gymnase Armand Coidelle </b> [10 Rue la Fayette]","<b> Gymnase du Lycée Vial </b> [12 Rue du 14 Juillet]","<b> Gymnase Leloup Bouhier </b> [11 Boulevard de Launay]","<b> Gymnase Gaston Serpette </b> [51 Boulevard Gaston Serpette]","<b> Gymnase du Breil Malville </b> [34 Rue du Breil]","<b> Gymnase ASPTT Appert </b> [38 Rue Nicolas Appert]","<b> Stade Marcel Saupin </b> [31 Quai Malakoff]","<b> Stade de la Beaujoire Louis Fonteneau </b> [330 Route de Saint Joseph]","<b> Plaine de Jeux Colinière </b> [121 Rue du Landreau]","<b> Plaine de Jeux Basses Landes </b> [6 Chemin de la Justice]","<b> Vélodrome Stade Petit Breton </b> [14 Rue de la Durantière]","<b> Plaine de Jeux Durantière </b> [11 Rue de la Durantière]","<b> Piscine du Petit Port </b> [Boulevard du Petit Port]","<b> Piscine Durantière </b> [11 Rue de la Durantière]","<b> Piscine Dervallières </b> [21 Rue Professeur Dubuisson]","<b> Piscine Léo Lagrange Ile Gloriette </b> [Rue Deurbroucq]","<b> Club Léo Lagranfe Nantes Aviron </b> [9 Chemin de Belle Ile]","<b> Golf Nantes Erdre </b> [90 Avenue du Bout des Landes]","<b> Base d'Aviron Universitaire </b> [2 Chemin de la Houssinière]","<b> Plaine de Jeux de la Beaujoire </b> [7 Rue du Fort]","<b> Stade La Halvêque </b> [23 Rue Léon Serpollet]","<b> Plateau Sportif du Port Boyer </b> [73 Rue du Port Boyer]","<b> Stade Annexe Louis Fonteneau </b> [330 Route de Saint Joseph]","<b> Espace de Proximité La Grande Noue </b> [10 Rue de la Bottière]","<b> Stade Caserne Quartier Mellinet </b> [4 Place du 51ième RA]","<b> Stade Gendarmerie Mobile </b> [4 Rue d'Allonville]","<b> Espace Sportif de Proximité du Clos Toreau </b> [3 Rue d'Hasparren]","<b> Stade de la Gilarderie </b> [115 Rue de la Gilarderie]","<b> Plaine de Jeux des Bourdonnières </b> [6 Rue de la Perrière]","<b> Gymnase ENITIA </b> [64 Rue de la Geraudiere]","<b> Stade Lycée La Chauvinière </b> [2 Rue de la Fantaisie]","<b> Plaine de Jeux du Petit Port </b> [2 Boulevard des Tribunes]","<b> Stade Launay Violette </b> [Impasse Charles Chassin]","<b> Stade Ecole Centrale </b> [32 Route de la Jonelière]","<b> Stade Procé </b> [13 Boulevard Clovis Constant]","<b> Stade Annexe de Procé </b> [Rue des Dervallières]","<b> Plaine de Jeux Bernardière </b> [Rue de la Fontaine Salée]","<b> Plaine de Jeux Lycée Albert Camus </b> [2 Rue du Bois de la Musse]","<b> Stade Lycée Carcouët </b> [115 Boulevard du Massacre]","<b> Plaine de Jeux des Dervallières </b> [19 Rue Jean Marc Nattier]","<b> Stade Pascal-Laporte </b> [74 Boulevard des Anglais]","<b> Gymnase Agenêts </b> [30 Rue du Casterneau]","<b> Gymnase Chantenay </b> [7 Rue de la Croix]","<b> Gymnase du Collège Talence </b> [122 Boulevard Robert Schuman]","<b> Piscine Jules Verne Haluchère </b> [41 Rue Jules Grandjouan]","<b> Stade Jean Jacques Audubon </b> [45 Rue Jean Jacques Audubon]","<b> Plaine de Jeux l'Eraudière </b> [11 Rue du Stade de la Noue]","<b> Equipement Sportif de Proximité La Halvêque </b> [23 Rue Léon Serpollet]","<b> Plaine de Jeux Marrière </b> [95 Rue de la Marrière]","<b> Plaine de Jeux Sévres </b> [Rue de l'Olivraie]","<b> Plaines de jeux Gaston Turpin </b> [33 Rue Gaston Turpin]","<b> Stade de la Gilarderie </b> [115 Rue de la Gilarderie]","<b> Stade l'Amande </b> [112 Route de la Chapelle Sur Erdre]","<b> Stade Michel Lecointre Beaulieu </b> [2 Boulevard Alexandre Millerand]","<b> Stade Pin Sec </b> [19 Rue Pierre Bouguer]","<b> Cercle d'Aviron de Nantes </b> [20 Rue d'Alsace]","<b> Plaine de Jeux Grand Blottereau </b> [Boulevard Auguste Péneau]","<b> Stade de la Roche </b> [10 Rue de la Révolution des Oeillets]","<b> Patinoire Olympique du Petit Port </b> [Boulevard du Petit Port]","<b> Plaine de Jeux Géraudière Santos Dumont </b> [Rue des Renards]","<b> Hippodrome du Petit Port </b> [2 Boulevard des Tribunes]","<b> Stade des Dervallières </b> [19 Rue Jean Marc Nattier]","<b> Gymnase du Lycée Jules Verne </b> [1 Rue Général Meusnier]","<b> Stade Mangin Beaulieu </b> [10 Rue Louis Joxe]","<b> Circuits Rustiques d'Activités Plein Air - Blottereau </b> [Boulevard Auguste Péneau]","<b> Circuits Rustiques d'Activités Plein Air - Ile de Nantes </b> [Square de la Délivrance]","<b> Plateau Sportif Bourgeonnière </b> [52 Rue de la Bourgeonnière]","<b> Gymnase Gigant </b> [3 Place Beaumanoir]","<b> Complexe Sportif de Saint Joseph de Porterie </b> [507 Route de Saint Joseph]","<b> Complexe Sportif Noë Lambert </b> [42 Boulevard des Poilus]","<b> Skatepark Le Hangar </b> [9 Allée des Vinaigriers]","<b> Gymnase Sully </b> [9 Rue Henri Cochard]","<b> Piscine Petite Amazonie </b> [15 Rue du Pont de l'Arche de Mauves]","<b> Skate Park Ricordeau </b> [Place Alexis Ricordeau]","<b> Terrain Multisport Monteil </b> [10 Rue Monteil]","<b> Boulodrome Noë Lambert </b> [20 Rue de la Haute Mitrie]","<b> Espace Sportif du Drac </b> [Rue du Drac]","<b> Espace Spotif des Courtils </b> [Rue des Courtils]","<b> Espace Sportif Square des Martyrs Irlandais </b> [Rue de l'Adour]","<b> Espace Square Le Gigan </b> [29 Rue du Fonteny]","<b> Espace Square Menier </b> [18 Rue du Parc Menier]","<b> Espace Sportif Terrain A. Fournier </b> [87 Rue du Bois Hardy]","<b> Espace Sportif Terrain du Petit Verger </b> [Avenue du Fruitier]","<b> Espace Sportif ZAC Montplaisir </b> [Allée des Alizés]","<b> Espace Sportif Meissonier </b> [Rue Ernest Meissonnier]","<b> Salle de Musculation du Jamet - Bellevue </b> [61 Route de Saint Herblain]","<b> Parc des Capucins </b> [14 Rue du Ballet]","<b> Gymnase Lycée Michelet </b> [41 Boulevard Michelet]","<b> Espace Sportif Malakoff </b> [Rue de Corse]","<b> Espace Sportif Noe Mitrie </b> [5 Boulevard Ernest Dalby]","<b> Espace Sportif Moutonnerie </b> [Rue Francisco Ferrer]","<b> Gymnase Caserne Gouzet </b> [47 Rue Maréchal Joffre]","<b> Gymnase Lycée Livet </b> [16 Rue Dufour]","<b> Espace Sportif J.B Barré </b> [Rue Jean Baptiste Barre]","<b> Espace Sportif du Vertais </b> [Boulevard Adolphe Billault]","<b> Espace Sportif Sébilleau </b> [Rue Docteur Jules Sébilleau]","<b> Boulodrome du Breil </b> [Rue de Malville]","<b> Square Gaston Michel </b> [28 Boulevard des Américains]","<b> Skate Schuman </b> [Boulevard Robert Schuman]","<b> Base Nautique de l'UNA </b> [Chemin de la Houssinière]","<b> Plateau Sportif Winnipeg </b> [Rue de Vancouver]","<b> Plateau Sportif André Chénier </b> [Rue André Chénier]","<b> Espace Sportif Paul Gauguin </b> [Rue Paul Gauguin]","<b> Plateau Sportif de la Géraudière </b> [Rue des Renards]","<b> Centre de Détention </b> [Boulevard Albert Einstein]","<b> Centre Sportif de la Faculté de Lettres </b> [Rue de l'Ile d'Yeu]","<b> UFR STAPS </b> [25 Boulevard Guy Mollet]","<b> Plaine de Jeux St-Joseph de Porterie </b> [Route de Saint Joseph]","<b> Equipement Sportif Jardin des 4 Jeudis </b> [Passage des Tauzins]","<b> Equipement Sportif Parc du Plessis Tison </b> [Rond-Point de Paris]","<b> Espace Sportif Louis Pergaud </b> [Route de Saint Joseph]","<b> Espace Sportif Ecole du Linot </b> [43B Rue du Port des Charrettes]","<b> Complexe Sportif Ecole des Mines </b> [4 Rue Alfred Kastler]","<b> Plaine de Jeux du Lycée de la Colinière </b> [129 Rue du Landreau]","<b> Halle de Tennis de la Marrière </b> [95 Rue de la Marrière]","<b> Equipement Sportif Marché de la Marrière </b> [27 Rue de la Marrière]","<b> Equipement Sportif du Square A. Fresnel </b> [Rue Augustin Fresnel]","<b> Plaine de Jeux de la Noë Lambert </b> [21 Route de Sainte Luce]","<b> Salle de Boxe Bottière Nantes Est </b> [83 Rue Félix Ménétrier]","<b> Equipement Sportif de la Haluchère </b> [Rue Jules Grandjouan]","<b> Equipement Sportif de la Bottière </b> [Rue Alfred Nobel]","<b> Equipement Sportif de la Pilotière </b> [Boulevard de la Pilotière]","<b> Gymnase Lycée L. de Vinci </b> [31 Rue de la Bottière]","<b> Boulodrome du Bèle </b> [16 Boulevard de la Beaujoire]","<b> Espace Sportif de Proximité de la Galerne </b> [Rue du Général de Bollardière]","<b> Espace Sportif Louis Le Nain </b> [Rue Louis Le Nain]","<b> Parc des dervallières </b> [Rue louis le nain]","<b> Jardin d'enfants de procé </b> [Rue des dervallières]","<b> Parc de proce </b> [Rue des dervallières, boulevard des anglais]","<b> Square amiral halgand </b> [Place de l'hotel de ville]","<b> Jardin des plantes </b> [Place charles leroux]","<b> Cours cambrone </b> [Rue des cadeniers]","<b> Square louis bureau </b> [Place de la monnaie]","<b> Square ile de versailles </b> [Quai de versailles]","<b> Square maquis de saffré </b> [Quai ceineray]","<b> Square jean-batiste daviais </b> [Place de la petite hollande]","<b> Jardin des cinq sens </b> [Rue celestin frenet ou rue gaetan rondeau]","<b> Square charles housset </b> [Rue charles housset]","<b> Square faustin hélie </b> [Rue faustin helie]","<b> Parc de la beaujoire </b> [Route de saint joseph]","<b> Parc du plessis tison </b> [Rond point de paris rue de racapé]","<b> Square maurice schwob </b> [Rue des garennes]","<b> Square elisa mercoeur </b> [Cours commandant estienne d'orves]","<b> Square marcel launay </b> [Boulevard general degaule]","<b> Square jean le gigant </b> [Rue maurice terrien]","<b> Square toussaint louverture </b> [Rue des usines]","<b> Parc des capucins </b> [Rue noire]","<b> Parc de la noe mitrie </b> [Boulevard ernest dalby]","<b> Square jean-baptiste barre </b> [Rue jean-baptiste barre]","<b> Square jules bréchoir </b> [Rue jules brechoir]","<b> Parc de malakoff </b> [Boulevard de sarrebruck]","<b> Square gustave roch </b> [Boulevard gustave roch]","<b> Place basse mar </b> [Place basse mar]","<b> Square vertais </b> [Boulevard des martyrs nantais de la resistance]","<b> Square du prinquiau </b> [Rue du prinquiau - boulevard de l'egalité]","<b> Square canclaux </b> [Place canclaux]","<b> Square des combattants d'afrique du nord </b> [Rue mathurin brissoneau - place rené bouhier]","<b> Square de l'edit de nantes </b> [Place de l'edit de nantes]","<b> Square marcel moisan </b> [Rue de l'hermitage]","<b> Square pascal lebee </b> [Place newton]","<b> Square etienne destranges </b> [Place edouard normand]","<b> Centre social de la pilotière </b> [Boulevard jules verne]","<b> Square augustin fresnel </b> [Rue augustin fresnel]","<b> Parc de broussais </b> [Place gabriel trarieux]","<b> Parc du grand-blottereau </b> [Boulevard auguste peneau]","<b> Square benoni goulin </b> [Rue du scorff]","<b> Square rue jules sebilleau </b> [Rue jules sebilleau]","<b> Parc say </b> [Rue desire colombe]","<b> Square de la marseillaise </b> [Rue du bois hercé - rue de la marseillaise]","<b> Square des marthyrs irlandais </b> [Rue francis portais - rue de l'adour]","<b> Square du bois de la musse </b> [Rue etienne coutan]","<b> Parc de la boucardiere </b> [Rue de l'abbaye - chemin de la petite boucardière]","<b> Square gaston michel </b> [Boulevard des américains]","<b> Jeux de boules proust bergson </b> [Rue marcel proust - rue henri bergson]","<b> Parc du petit port </b> [Boulevard des tribunes]","<b> Parc de beaulieu </b> [Cours de la prairie d'amont]","<b> Square gabriel chéreau </b> [Rue d'ancin]","<b> Square des courtils </b> [Rue des courtils]","<b> Cimetiere paysager </b> [Rond-point jean moulin]","<b> Square saint françois </b> [Rue saint francois]","<b> Jardin des quatre jeudis </b> [Rue de l'embellie saint joseph de porterie]","<b> Jardin du nadir </b> [Rue du nadir saint joseph de porterie]","<b> Jardin du zenith </b> [Rue tristan corbieres saint joseph de porterie]","<b> Jardin des farfadets </b> [Allee de portrick saint joseph de porterie]","<b> Parc de la chantrerie </b> [Route de gachet]","<b> Parc de la moutonnerie </b> [Rue francisco ferrer]","<b> Abords du stade de la beaujoire </b> [Route de saint joseph]","<b> Square du vieux parc de sèvre </b> [Avenue camille guerin]","<b> Le parc des chantiers </b> [Boulevard léon bureau - boulevard de la prairie au]","<b> Parc de la gaudiniere </b> [Carrefour patouillerie - robert schuman]","<b> Square de la halvèque </b> [Rue leon serpollet]","<b> Square jean heurtin </b> [Quai ferdinand favre]","<b> Parc potager de la crapaudine </b> [Avenue des palmiers]","<b> Place de la guirouée </b> [Place de la guirouee]","<b> Square barbara </b> [Rue de la grange au loup]","<b> Square du lait de mai </b> [Rue berthault]","<b> Square des maraiches </b> [Rue de la haluchère - rue emile gadeceau]","<b> Square louis feuillade </b> [Rue jacques feyder]","<b> Jardin mabon </b> [Quai françois mitterrand]","<b> Jardin des nectars </b> [Petite avenue de lonchamp]","<b> Le jardin des fonderies </b> [Rue louis joxe - allée des hélices - rue de récife]","<b> Aire de jeux des renards </b> [Rues stéphane leduc - de la petite sensive - de rome - des renards - dorsay]","<b> Espace de jeux de belle ile </b> [Rue coetquelfen]","<b> Parc pablo picasso </b> [Mail pablo picasso]","<b> Square psalette </b> [Cours st pierre - impasse st laurent - impasse de la psalette]","<b> Douves du château des ducs </b> [Rue des etats]","<b> Square saint pasquier </b> [Place emile fritsch]","<b> Jardin confluent </b> [Rue dos d'ane]","<b> Square félix thomas </b> [Rue toulmouche - rue félix thomas]","<b> Parc potager croissant </b> [Avenue jacques auneau - rue des clématites]","<b> Place wattignies </b> [Place wattignies - rue de l'echappée - rue petite biesse]","<b> Square pilotière </b> [Boulevard de la pilotière - boulevard jules verne]","<b> Parc potager amande </b> [Boulevard albert einstein]","<b> Square hongrie </b> [Rue de hongrie - rue de chypre]","<b> Parc potager fournillère </b> [Rue jules piedeleu]","<b> Square zac pilleux nord </b> [Rue de pilleux - rue benoit frachon]"]
		});
   	</script>

</body>
</html>
