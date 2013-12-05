package beans;

import java.io.Serializable;
import java.util.ArrayList;

import classes.UserClass;

public class UsersBean implements Serializable {
	ArrayList<UserClass> users;
	
	public UsersBean() {
		users = new ArrayList<UserClass>();
	}
	
	public boolean addUser(UserClass newUser) {
		if(!newUser.isInArray(users)) {
			return users.add(newUser);
		}
		return false;
	}
	
	public void removeUser(UserClass ancientUser) {
		if(containsUser(ancientUser)) {
			users.remove(ancientUser.indexInArray(users));
		}
	}
	
	public boolean containsUser(UserClass user) {
		return user.isInArray(users);
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
