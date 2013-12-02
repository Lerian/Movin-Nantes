package classes;

import java.io.Serializable;
import java.util.ArrayList;

public class UserClass implements Serializable{
	String mail;
	String name;
	ArrayList<EventClass> eventsCreated;
	ArrayList<EventClass> eventsJoined;
	ArrayList<String> favoriteSports;
	
	public UserClass(String n, String m) {
		mail = m;
		name = n;
		eventsCreated = new ArrayList<EventClass>();
		eventsJoined = new ArrayList<EventClass>();
		favoriteSports = new ArrayList<String>();
	}
	
	public UserClass(String m) {
		mail = m;
		name = "Unknown user";
		eventsCreated = new ArrayList<EventClass>();
		eventsJoined = new ArrayList<EventClass>();
		favoriteSports = new ArrayList<String>();
	}
	
	public String getName() {
		return name;
	}
	
	public String getMail() {
		return mail;
	}
	
	public int getNumberOfSports() {
		return favoriteSports.size();
	}
	
	public String getSport(int i) {
		if (i < favoriteSports.size() && i >= 0)
			return favoriteSports.get(i);
		else
			return null;
	}
	
	public boolean favorsSport(String s) {
		for(int i = 0; i< favoriteSports.size();i++)
			if (favoriteSports.get(i).toLowerCase().equals(s.toLowerCase()))
				return true;
		return false;
	}
	
	public void addSport(String s) {
		if (!favorsSport(s))
			favoriteSports.add(s.toLowerCase());
	}
	
	public void removeSport(String s) {
		if (favorsSport(s))
			favoriteSports.remove(favoriteSports.indexOf(s.toLowerCase()));
	}
	
	public void setName(String n) {
		if(n != null)
			name = n;
	}
	
	public void setMail(String m) {
		mail = m;
	}
	
	public String toString() {
		return new String(name+" : "+mail);
	}
	
	public boolean isInArray(ArrayList<UserClass> array) {
		for(int i=0;i<array.size();i++) {
			if(mail.equals(array.get(i).getMail()))
				return true;
		}
		return false;
	}
	
	public int indexInArray(ArrayList<UserClass> array) {
		for(int i=0;i<array.size();i++) {
			if(mail.equals(array.get(i).getMail()))
				return i;
		}
		return -1;
	}
	
	public boolean equals(UserClass user) {
		return mail.equals(user.getMail());
	}
	
	public void addEventCreated(EventClass newEvent) {
		if(!newEvent.isInArray(eventsCreated)) {
			eventsCreated.add(newEvent);
		}
	}
	
	public void removeEventCreated(EventClass oldEvent) {
		if(containsEventCreated(oldEvent)) {
			eventsCreated.remove(oldEvent.indexInArray(eventsCreated));
		}
	}
	
	public EventClass getEventCreated(int i) {
		if (i < eventsCreated.size())
			return eventsCreated.get(i);
		else
			return null;
	}
	
	public EventClass getEventCreatedById(String id_s) {
		int id = Integer.parseInt(id_s);
		for (int i=0;i<eventsCreated.size();i++) {
			if (eventsCreated.get(i).hashCode() == id)
				return eventsCreated.get(i);
		}
		return null;
	}
	
	public EventClass getEventCreatedById(int id) {
		for (int i=0;i<eventsCreated.size();i++) {
			if (eventsCreated.get(i).hashCode() == id)
				return eventsCreated.get(i);
		}
		return null;
	}
	
	public boolean containsEventCreated(EventClass event) {
		return event.isInArray(eventsCreated);
	}
	
	public int getNumberOfEventsCreated() {
		return eventsCreated.size();
	}
	
	public void addEventJoined(EventClass newEvent) {
		if(!newEvent.isInArray(eventsJoined)) {
			eventsJoined.add(newEvent);
		}
	}
	
	public void removeEventJoined(EventClass oldEvent) {
		if(containsEventJoined(oldEvent)) {
			eventsJoined.remove(oldEvent.indexInArray(eventsJoined));
		}
	}
	
	public EventClass getEventJoined(int i) {
		if (i < eventsJoined.size())
			return eventsJoined.get(i);
		else
			return null;
	}
	
	public EventClass getEventJoinedById(String id_s) {
		int id = Integer.parseInt(id_s);
		for (int i=0;i<eventsJoined.size();i++) {
			if (eventsJoined.get(i).hashCode() == id)
				return eventsJoined.get(i);
		}
		return null;
	}
	
	public EventClass getEventJoinedById(int id) {
		for (int i=0;i<eventsJoined.size();i++) {
			if (eventsJoined.get(i).hashCode() == id)
				return eventsJoined.get(i);
		}
		return null;
	}
	
	public boolean containsEventJoined(EventClass event) {
		return event.isInArray(eventsJoined);
	}
	
	public int getNumberOfEventsJoined() {
		return eventsJoined.size();
	}
}
