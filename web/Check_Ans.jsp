<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="Connection.DbConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <%
    String aadharNo = request.getParameter("Aadhar"); // Assuming Aadhar number is available from the request
    if (aadharNo == null) {
        response.sendRedirect("index.jsp"); // Redirect if aadhar_no is not available
        return;
    }
    
    boolean allAnswersCorrect = true;
    
    // Retrieve answers submitted by the user
    ArrayList<String> userAnswers = new ArrayList<>();
    for (int i = 0; i < 10; i++) {
        String userAnswer = request.getParameter("answer1_" + i);
        if (userAnswer != null && !userAnswer.trim().isEmpty()) {
            userAnswers.add(userAnswer.trim());
        } else {
            userAnswers.add(""); // In case user didn't answer a question
        }
    }

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.jdbc.Driver"); // Adjust this for your JDBC driver
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ip", "root", "admin"); // Replace with actual database details

        // Retrieve the correct answers from the database
        stmt = conn.prepareStatement("SELECT answer FROM security_questions WHERE aadhar_no = ? ORDER BY ques_id LIMIT 10");
        stmt.setString(1, aadharNo);
        rs = stmt.executeQuery();

        int index = 0;
        while (rs.next()) {
            String correctAnswer = rs.getString("answer");
            String userAnswer = userAnswers.get(index);

            // Check if the user's answer is correct
            if (!userAnswer.equalsIgnoreCase(correctAnswer)) {
                allAnswersCorrect = false;
            }
            index++;
        }

        rs.close();
        stmt.close();

        // If all answers are correct, update user_reg table
        if (allAnswersCorrect) {
            stmt = conn.prepareStatement("UPDATE user_reg SET sts = 'ACTIVE' WHERE aadhar_no = ?");
            stmt.setString(1, aadharNo);
            stmt.executeUpdate();
             session.setAttribute("msg", "All answers are correct! Your account is now ACTIVE.");
                    response.sendRedirect("index.jsp");
        } else {
            // If some answers are incorrect, update mail table
            stmt = conn.prepareStatement("UPDATE mail SET Count = 0 WHERE aadhar_no = ?");
            stmt.setString(1, aadharNo);
            stmt.executeUpdate();
              session.setAttribute("msg", "Some answers are incorrect. Please try again.");
                    response.sendRedirect("index.jsp");
        }

        stmt.close();

    } catch (Exception e) {
        e.printStackTrace();
        allAnswersCorrect = false;
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
    %>
</html>
