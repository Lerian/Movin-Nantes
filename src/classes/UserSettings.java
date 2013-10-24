package classes;

import java.util.ArrayList;

public class UserSettings {
	ArrayList<String> places;
	ArrayList<String> sports;
	
	public void addPlace(String name) {
		if(!places.contains(name))
			places.add(name);
	}
	
	public void addSport(String name) {
		if(!sports.contains(name))
			sports.add(name);
	}
	
	public void removePlace(String name) {
		if(places.contains(name))
			places.remove(name);
	}
	
	public void removeSport(String name) {
		if(sports.contains(name))
			sports.remove(name);
	}
}
