<%@page import="java.time.LocalDate"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DbConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <%
    String aadharNo = request.getParameter("Aadhar"); // Assuming aadhar_no is stored in the session after login

    if (aadharNo == null) {
        response.sendRedirect("login.jsp"); // Redirect if aadhar_no is not available
        return;
    }

    // List to store questions and answers
    ArrayList<String[]> questionsSet1 = new ArrayList<>();
    boolean isSet1Correct = true;
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.jdbc.Driver"); // Adjust this for your JDBC driver
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ip", "root", "admin"); // Replace with actual database details

        // Retrieve a random first set of 5 questions for the user
        stmt = conn.prepareStatement("SELECT ques_id, question, answer FROM security_questions WHERE aadhar_no = ? ORDER BY RAND() LIMIT 10");
        stmt.setString(1, aadharNo);
        rs = stmt.executeQuery();

        // Add first set of random questions to questionsSet1
        while (rs.next()) {
            String[] questionData = {rs.getString("ques_id"), rs.getString("question"), rs.getString("answer")};
            questionsSet1.add(questionData);
        }
        rs.close();
        stmt.close();

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }

    DbConnection db = new DbConnection();
    ResultSet rs1 = db.Select("SELECT * FROM mail WHERE aadhar_no = '" + aadharNo + "'");

    if (rs1.next()) {
        int mailCount = rs1.getInt("count"); // Assuming 'count' is the column that holds the value 0 or 1

        // Check if the count is 1 or 0
        if (mailCount == 1) {
            LocalDate currentDate = LocalDate.now();
            LocalDate current_date = rs1.getDate("current_date").toLocalDate();

            // Check if the request date is equal to the current date
            if (currentDate.isEqual(current_date)) {
    %>
                <body>
                    <center>
                        <h1 style="color: #000080; background-color: #dd9fd1; padding: 8px; margin-bottom: 0px; font-weight: bold;">ANSWER ALL QUESTIONS</h1>
                        <form method="post" action="Check_Ans.jsp">
                            <% 
                            for (int i = 0; i < questionsSet1.size(); i++) {
                                String question = questionsSet1.get(i)[1];
                            %>
                            <p><%= question %></p>
                            <input type="text" name="answer1_<%= i %>" required /><br>
                            <% } %>
                            <input type="hidden" name="Aadhar" value="<%= aadharNo %>" />
                            <input type="submit" name="submitSet1" value="Submit" />
                        </form>
                    </center>
                </body>
    <%
            } else {
                out.println("<h2>YOUR REQUEST DATE IS OVER. PLEASE SEND MAIL AGAIN.</h2>");
                out.println("<form action='Check_Ans.jsp' method='get'>");
                out.println("<button type='submit' class='allocate-btn'>Back</button>");
                out.println("</form>");
            }
        } else {
          // If the count is 0, block access
out.println("<h2>YOUR ATTEMPT IS OVER. YOUR ACCOUNT IS PERMANENTLY BLOCKED.</h2>");
out.println("<form action='Check_Ans.jsp' method='get'>");
out.println("<button type='submit' class='allocate-btn'>Back</button>");
out.println("</form>");

        }
    } else {
        out.println("<div class='error'>No request found.</div>");
    }
    %>
</html>
