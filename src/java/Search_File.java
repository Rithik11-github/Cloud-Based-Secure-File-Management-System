import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import Connection.DbConnection;

@WebServlet("/Search_File")
public class Search_File extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the logged-in user's Aadhar number or email from the session
        String loggedInAadharNo = (String) request.getSession().getAttribute("aadhar_no");
        String loggedInEmail = (String) request.getSession().getAttribute("email");

        if (loggedInAadharNo != null || loggedInEmail != null) {
            String searchCriteria = request.getParameter("searchCriteria"); // Search term from user
            String searchValue = request.getParameter("searchValue"); // Value to search (file name, aadhar no, email)

            if (searchValue != null && !searchValue.isEmpty()) {
                try {
                    DbConnection db = new DbConnection();

                    // SQL query to search for files uploaded by the logged-in user
                    String query = "SELECT * FROM documents WHERE (file_name LIKE ? OR aadhar_no = ? OR email = ?) AND (aadhar_no = ? OR email = ?)";
                    PreparedStatement pstmt = db.con.prepareStatement(query);
                    pstmt.setString(1, "%" + searchValue + "%");  // Use LIKE for searching file name
                    pstmt.setString(2, searchValue);  // Exact match for Aadhar number
                    pstmt.setString(3, searchValue);  // Exact match for email
                    pstmt.setString(4, loggedInAadharNo);  // Filter by logged-in user's Aadhar number
                    pstmt.setString(5, loggedInEmail);  // Filter by logged-in user's email

                    ResultSet rs = pstmt.executeQuery();

                    // Forward the result set to a JSP page to display the results
                    request.setAttribute("searchResults", rs);
                    request.getRequestDispatcher("search_results.jsp").forward(request, response);

                } catch (SQLException e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Error during file search: " + e.getMessage());
                    request.getRequestDispatcher("search_results.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Please enter a valid search term.");
                request.getRequestDispatcher("search_results.jsp").forward(request, response);
            }
        } else {
            // If user is not logged in, show an error message
            request.setAttribute("error", "You must be logged in to search files.");
            request.getRequestDispatcher("search_results.jsp").forward(request, response);
        }
    }
}
