package classes;

import java.io.Serializable;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.ArrayList;

public class EventClass implements Serializable{
	String sport;
	String lieu;
	int places;
	GregorianCalendar date;
	String description;
	UserClass organisateur;
	int id;
	
	public String getSport() {
		return sport;
	}
	
	public String getLieu() {
		return lieu;
	}
	
	public int getPlaces() {
		return places;
	}
	
	public GregorianCalendar getDate() {
		return date;
	}
	
	public String getDateString() {
		String res = String.valueOf(date.get(Calendar.DAY_OF_MONTH))+
				"/"+
				String.valueOf(date.get(Calendar.MONTH)+1)+
				"/"+
				String.valueOf(date.get(Calendar.YEAR));
		return res;
	}
	
	public String getDescription() {
		return description;
	}
	
	public UserClass getOrganisateur() {
		return organisateur;
	}
	
	public EventClass(String s, String l, int p, GregorianCalendar da, String de, UserClass o) {
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
		String day[] = da.split("-");
		date = new GregorianCalendar(Integer.parseInt(day[2]),Integer.parseInt(day[1])-1,Integer.parseInt(day[0]));
		description = de;
		organisateur = o;
	}
	
	public void addAPlace() {
		places++;
	}
	
	public void removeAPlace() {
		places--;
	}
	
	/*public boolean isInArray(ArrayList<EventClass> array) {
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
	}*/
	public boolean isInArray(ArrayList<EventClass> array) {
		for(int i=0;i<array.size();i++) {
			if(this.hashCode() == array.get(i).hashCode())
				return true;
		}
		return false;
	}
	/*public int indexInArray(ArrayList<EventClass> array) {
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
	}*/
	public int indexInArray(ArrayList<EventClass> array) {
		for(int i=0;i<array.size();i++) {
			if(this.hashCode() == array.get(i).hashCode())
				return i;
		}
		return -1;
	}
	public String toString() {
		return "EventClass.toString to be implemented x)";
	}
}
