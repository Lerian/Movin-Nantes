package beans;

import java.io.Serializable;
import classes.UserClass;

public class UserBean implements Serializable {
	UserClass user;
	
	public UserBean() {
		user = null;
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
	
	public void setName(String n) {
		user.setName(n);
	}
	
	public void setMail(String m) {
		user.setMail(m);
	}
}
