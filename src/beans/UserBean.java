package beans;

import java.io.Serializable;

import classes.UserClass;
import classes.EventClass;

public class UserBean implements Serializable {
	UserClass user;
	
	public UserBean() {
		user = null;
	}
	
	public UserClass getUser() {
		return user;
	}
	
	public void setUser(UserClass model, String mail) {
			if (model != null)
				user = model;
			else
				user = new UserClass(mail);
	}
	
	public String getName() {
		return user.getName();
	}
	
	public String getMail() {
		return user.getMail();
	}
	
	public int getNumberOfSports() {
		return user.getNumberOfSports();
	}
	
	public String getSport(int i) {
		return user.getSport(i);
	}
	
	public boolean favorsSport(String s) {
		return user.favorsSport(s);
	}
	
	public void addSport(String s) {
		user.addSport(s);
	}
	
	public void removeSport(String s) {
		user.removeSport(s);
	}
	
	public int getNumberOfPlaces() {
		return user.getNumberOfPlaces();
	}
	
	public String getPlace(int i) {
		return user.getPlace(i);
	}
	
	public boolean favorsPlace(String s) {
		return user.favorsPlace(s);
	}
	
	public void addPlace(String s) {
		user.addPlace(s);
	}
	
	public void removePlace(String s) {
		user.removePlace(s);
	}
	
	public void setName(String n) {
		user.setName(n);
	}
	
	public void setMail(String m) {
		user.setMail(m);
	}
	
	public boolean nameIsDefault() {
		return "Unknown user".equals(getName());
	}
	
	public void addEventCreated(EventClass newEvent) {
			user.addEventCreated(newEvent);
	}
	
	public void removeEventCreated(EventClass oldEvent) {
			user.removeEventCreated(oldEvent);
	}
	
	public EventClass getEventCreated(int i) {
		return user.getEventCreated(i);
	}
	
	public EventClass getEventCreatedById(String id) {
		return user.getEventCreatedById(id);
	}
	
	public EventClass getEventCreatedById(int id) {
		return user.getEventCreatedById(id);
	}
	
	public int getNumberOfEventsCreated() {
		return user.getNumberOfEventsCreated();
	}
	
	public void addEventJoined(EventClass newEvent) {
			user.addEventJoined(newEvent);
	}
	
	public void removeEventJoined(EventClass oldEvent) {
			user.removeEventJoined(oldEvent);
	}
	
	public EventClass getEventJoined(int i) {
		return user.getEventJoined(i);
	}
	
	public EventClass getEventJoinedById(String id) {
		return user.getEventJoinedById(id);
	}
	
	public EventClass getEventJoinedById(int id) {
		return user.getEventJoinedById(id);
	}
	
	public int getNumberOfEventsJoined() {
		return user.getNumberOfEventsJoined();
	}
}
