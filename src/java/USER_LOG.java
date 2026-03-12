import Connection.DbConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.time.Instant;

@WebServlet(urlPatterns = {"/USER_LOG"})
public class USER_LOG extends HttpServlet {

    private static final int MAX_ATTEMPTS = 3;
    private static final int COOLDOWN_PERIOD = 40; // Cooldown period in seconds

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(true);

        // Retrieve login credentials from the form
        String aadhar_no = request.getParameter("aadhar_no");
        String password = request.getParameter("Password");

        try {
            // Initialize or increment attempt count
            Integer attemptCount = (Integer) session.getAttribute("attemptCount");
            if (attemptCount == null) {
                attemptCount = 0;
            }

            // Check if the user is locked out and if the cooldown period has expired
            Long lockoutTime = (Long) session.getAttribute("lockoutTime");
            if (lockoutTime != null) {
                long timeElapsed = Instant.now().getEpochSecond() - lockoutTime;
                
                if (timeElapsed < COOLDOWN_PERIOD) {
                    // Still in cooldown period, redirect to lockout page
                    response.sendRedirect("index_3.jsp");
                    return;
                } else {
                    // Cooldown period has expired, reset lockout
                    session.removeAttribute("lockoutTime");
                    attemptCount = 0; // Reset attempts after cooldown
                }
            }

            // Database connection and query execution
            DbConnection connection = new DbConnection();
            String query = "SELECT * FROM user_reg WHERE aadhar_no='" + aadhar_no + "' AND password='" + password + "'";
            ResultSet rs = connection.Select(query);

            if (rs.next()) {
                
                String st=rs.getString("sts");
              if(st.equals("BLOCKED"))
              {
                  session.setAttribute("msg","YOUR ACCOUNT BLOCKED!!");
                  response.sendRedirect("USER_LOGIN.jsp");
              }
              else if(st.equals("INACTIVE"))
              {
                  session.setAttribute("msg","Add Security Question link sent your email ");
                  response.sendRedirect("USER_LOGIN.jsp");
              }else{
                  
             
                // Successful login, reset attempt count and session attributes
                int user_id = rs.getInt("user_id");
                String username=rs.getString("username");
                session.setAttribute("msg", "Successfully Logged In");
                session.setAttribute("user_id", user_id);
                session.setAttribute("aadhar_no", aadhar_no);
                session.setAttribute("username", username);
                session.removeAttribute("attemptCount");
                session.removeAttribute("lockoutTime");
                response.sendRedirect("USER_ANS.jsp");
            }
            } else {
                // Increment attempt count and check if maximum attempts are reached
                attemptCount++;
                session.setAttribute("attemptCount", attemptCount);

                if (attemptCount >= MAX_ATTEMPTS) {
                    // Set lockout time to the current timestamp and redirect to lockout page
                    session.setAttribute("lockoutTime", Instant.now().getEpochSecond());
                    response.sendRedirect("index_3.jsp");
                } else {
                    // Redirect back to login page for another attempt
                    response.sendRedirect("USER_LOGIN.jsp");
                }
            }
        } catch (Exception ex) {
            out.println("An error occurred: " + ex.getMessage());
        } finally {
            out.close();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "User Login Servlet with Lockout after 3 failed attempts and 30-second cooldown";
    }
}
