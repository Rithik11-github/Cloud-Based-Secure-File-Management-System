import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/BLOCK")
public class BLOCK extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database details
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/ip";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "admin";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        String aadharNo = (String) session.getAttribute("aadhar_no"); // Retrieve Aadhaar number from session

        if (aadharNo != null) {
            Connection conn = null;
            PreparedStatement stmt = null;

            try {
                // Load the JDBC driver and establish a connection
                Class.forName("com.mysql.jdbc.Driver"); // Updated to the correct driver class name
                conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);

                // Prepare SQL query to update the sts column
                String sql = "UPDATE user_reg SET sts = ? WHERE aadhar_no = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, "BLOCKED"); // Set the sts value to "BLOCKED"
                stmt.setString(2, aadharNo);

                // Execute the update
                int rowsUpdated = stmt.executeUpdate();
                
                if (rowsUpdated > 0) {
                    // Set a session attribute to indicate that the account was blocked
                    session.setAttribute("msg", "YOUR ACCOUNT HAS BEEN BLOCKED.");
                    response.sendRedirect("USER_LOGIN.jsp");
                } else {
                    // Handle case where no rows were updated (Aadhaar number not found)
                    session.setAttribute("msg", "Aadhaar number not found.");
                    response.sendRedirect("USER_LOGIN.jsp");
                }
                
            } catch (Exception e) {
                e.printStackTrace();
                // Set session message for error case
                session.setAttribute("msg", "An error occurred while blocking your account.");
                response.sendRedirect("USER_LOGIN.jsp");
            } finally {
                // Close resources
                try { if (stmt != null) stmt.close(); } catch (Exception e) { e.printStackTrace(); }
                try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
            }
        } else {
            // Redirect to login if the session attribute is missing
            response.sendRedirect("USER_LOGIN.jsp");
        }
    }
}
