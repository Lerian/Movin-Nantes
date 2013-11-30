package beans;

import java.io.Serializable;
import java.util.ArrayList;

import classes.EventClass;
import classes.UserClass;

public class EventsBean implements Serializable{
	ArrayList<EventClass> events;
	
	public EventsBean() {
		events = new ArrayList<EventClass>();
	}
	
	public int getSize() {
		return events.size();
	}
	

	public EventClass getEvent(int i) {
		if (i < events.size())
			return events.get(i);
		else
			return null;
	}
	
	public void addEvent(EventClass newEvent) {
		if(!newEvent.isInArray(events)) {
			events.add(newEvent);
		}
	}
	
	public void removeEvent(EventClass oldEvent) {
		if(containsEvent(oldEvent)) {
			events.remove(oldEvent.indexInArray(events));
		}
	}
	
	public boolean containsEvent(EventClass event) {
		return event.isInArray(events);
	}
}
