package classes;

import java.io.Serializable;
import java.util.ArrayList;

public class UserClass implements Serializable{
	String mail;
	String name;
	ArrayList<EventClass> eventsCreated;
	
	public UserClass(String n, String m) {
		mail = m;
		name = n;
		eventsCreated = new ArrayList<EventClass>();
	}
	
	public UserClass(String m) {
		mail = m;
		name = "Unknown user";
		eventsCreated = new ArrayList<EventClass>();
	}
	
	public String getName() {
		return name;
	}
	
	public String getMail() {
		return mail;
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
	
	public boolean containsEventCreated(EventClass event) {
		return event.isInArray(eventsCreated);
	}
	
	public int getNumberOfEventsCreated() {
		return eventsCreated.size();
	}
}
