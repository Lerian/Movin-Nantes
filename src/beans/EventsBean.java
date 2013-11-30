package beans;

import java.io.Serializable;
import java.util.ArrayList;

import classes.EventClass;
import classes.UserClass;

public class EventsBean implements Serializable{
	ArrayList<EventClass> events;
	
	public void addEvent(EventClass newEvent) {
		events.add(newEvent);
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
