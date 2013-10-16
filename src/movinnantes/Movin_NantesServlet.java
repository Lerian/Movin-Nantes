package movinnantes;

import java.io.IOException;
import javax.servlet.http.*;

@SuppressWarnings("serial")
public class Movin_NantesServlet extends HttpServlet {
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		resp.setContentType("text/plain");
		resp.getWriter().println("Coming soon !!!");
	}
}
