import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/QUESTION_ANS")
public class QUESTION_ANS extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
         HttpSession session = request.getSession(true);

        Connection conn = null;
        PreparedStatement psInsert = null;
        PreparedStatement psUpdate = null;

        try {
            // Get a connection to the database
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ip", "root", "admin");

            // Insert security questions and answers
            String insertQuery = "INSERT INTO security_questions (question, answer, aadhar_no) VALUES (?, ?, ?)";
            psInsert = conn.prepareStatement(insertQuery);

            // Get the Aadhar number from the request
            String aadhar_no = request.getParameter("aadhar_no");

            // Loop through form fields for each question and answer pair
            for (int i = 1; i <= 10; i++) {
                String question = request.getParameter("question_" + i);
                String answer = request.getParameter("answer_" + i);

                if (question != null && !question.isEmpty() && answer != null && !answer.isEmpty()) {
                    psInsert.setString(1, question);
                    psInsert.setString(2, answer);
                    psInsert.setString(3, aadhar_no);
                    psInsert.addBatch();
                }
            }

            // Execute batch insert
            int[] insertResults = psInsert.executeBatch();

            // Check if questions were successfully uploaded
            if (insertResults.length > 0) {
                // Update the user_reg table
                String updateQuery = "UPDATE user_reg SET sts = 'ACTIVE' WHERE aadhar_no = ?";
                psUpdate = conn.prepareStatement(updateQuery);
                psUpdate.setString(1, aadhar_no);

                int updateResult = psUpdate.executeUpdate();

                if (updateResult > 0) {
                    session.setAttribute("msg", "Security questions uploaded successfully!");
                    response.sendRedirect("USER_LOGIN.jsp");
                } else {
                     session.setAttribute("msg", "Security questions uploaded, but user status update failed.");
                    response.sendRedirect("index.jsp");
                }
            } else {
                 session.setAttribute("msg", "No questions submitted!");
                    response.sendRedirect("index.jsp");
            }
        } catch (SQLException e) {
            out.println("<h3>Error occurred: " + e.getMessage() + "</h3>");
            e.printStackTrace();
        } finally {
            // Clean up resources
            try {
                if (psInsert != null) psInsert.close();
                if (psUpdate != null) psUpdate.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
