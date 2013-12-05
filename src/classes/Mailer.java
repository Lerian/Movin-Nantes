package classes;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class Mailer extends MimeMessage {
	
	public Mailer(Session sess, String msgBody, String receiverMail, String receiverName, String subject) {
		
		super(sess);
	
		try {
		    setFrom(new InternetAddress("movinNantesMailer@gmail.com", "Movin'Nantes Mailer"));
		    addRecipient(Message.RecipientType.TO, new InternetAddress(receiverMail, receiverName));
		    setSubject(subject);
		    setText(msgBody);
		    Transport.send(this);
	
		} catch (Exception e) {
		    //TODO faire un truc
		}
	}
}
