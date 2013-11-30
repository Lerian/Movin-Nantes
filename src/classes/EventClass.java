package classes;

import java.io.Serializable;
import java.util.Date;
import java.util.ArrayList;

public class EventClass implements Serializable{
	String sport;
	String lieu;
	int places;
	Date date;
	String description;
	UserClass organisateur;
	
	public String getSport() {
		return sport;
	}
	
	public String getLieu() {
		return lieu;
	}
	
	public int getPlaces() {
		return places;
	}
	
	public Date getDate() {
		return date;
	}
	
	public String getDescription() {
		return description;
	}
	
	public UserClass getOrganisateur() {
		return organisateur;
	}
	
	public EventClass(String s, String l, int p, Date da, String de, UserClass o) {
		sport = s;
		lieu = l;
		places = p;
		date = da;
		description = de;
		organisateur = o;
	}
	
	public EventClass(String s, String l, String p, String da, String de, UserClass o) {
		sport = s;
		lieu = l;
		places = Integer.parseInt(p);
		date = new Date(/*da*/);
		description = de;
		organisateur = o;
	}
	
	public void removeAPlace() {
		places--;
	}
	
	public boolean isInArray(ArrayList<EventClass> array) {
		for(int i=0;i<array.size();i++) {
			if(sport.equals(array.get(i).getSport())
					&&
					lieu.equals(array.get(i).getLieu())
					&&
					date.equals(array.get(i).getDate())
					&&
					organisateur.equals(array.get(i)))
				return true;
		}
		return false;
	}
	
	public int indexInArray(ArrayList<EventClass> array) {
		for(int i=0;i<array.size();i++) {
			if(sport.equals(array.get(i).getSport())
					&&
					lieu.equals(array.get(i).getLieu())
					&&
					date.equals(array.get(i).getDate())
					&&
					organisateur.equals(array.get(i)))
				return i;
		}
		return -1;
	}
	
	public String toString() {
		return "trololo!!";
	}
}
