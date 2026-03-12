import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import Connection.DbConnection;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/VerifyMailServlet")
public class VerifyMailServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fromMail = request.getParameter("from_mail");
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        // Use the existing DbConnection class
        DbConnection dbConnection = new DbConnection();
        Connection con = dbConnection.con;  // Get the existing connection

        // Prepare and execute the query
        String query = "SELECT aadhar_no FROM user_reg WHERE email = ?";
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, fromMail);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String aadhar = rs.getString("aadhar_no");
                out.print(aadhar);  // Send the Aadhar number to the client
            } else {
                out.print("not_found");  // Indicate the email wasn't found
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.print("error");  // Handle error
        }
    }
}
