package beans;

import java.io.Serializable;
import java.util.ArrayList;

import classes.UserClass;

public class UsersBean implements Serializable {
	ArrayList<UserClass> users;
	
	public UsersBean() {
		users = new ArrayList<UserClass>();
	}
	
	public void addUser(UserClass newUser) {
		if(!newUser.isInArray(users)) {
			users.add(newUser);
		}
	}
	
	public void removeUser(UserClass ancientUser) {
		if(users.contains(ancientUser)) {
			users.remove(users.indexOf(ancientUser));
		}
	}
	
	public boolean containsUser(UserClass user) {
		return users.contains(user);
	}
	
	public String getUserString(int i) {
		if(i < users.size())
			return users.get(i).toString();
		else
			return null;
	}
	
	public UserClass getUser(String mail) {
		for(int i=0;i<users.size();i++) {
			if(mail.equals(users.get(i).getMail())) {
				return users.get(i);
			}
		}
		return null;
	}
	
	public int getSize() {
		return users.size();
	}
}
