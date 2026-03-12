<%@ page import="java.sql.*, java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%
    String aadharNo = (String) session.getAttribute("aadhar_no"); // Assuming aadhar_no is stored in the session after login

    if (aadharNo == null) {
        response.sendRedirect("login.jsp"); // Redirect if aadhar_no is not available
        return;
    }

    ArrayList<String[]> questionsSet1 = new ArrayList<>();
    boolean isSet1Correct = true;

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.jdbc.Driver"); // Adjust this for your JDBC driver
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ip", "root", "admin"); // Replace with actual DB details

        // If first time, generate random questions
        if (session.getAttribute("questionsSet1") == null) {
            stmt = conn.prepareStatement("SELECT ques_id, question, answer FROM security_questions WHERE aadhar_no = ? ORDER BY RAND() LIMIT 5");
            stmt.setString(1, aadharNo);
            rs = stmt.executeQuery();

            while (rs.next()) {
                String[] questionData = {rs.getString("ques_id"), rs.getString("question"), rs.getString("answer")};
                questionsSet1.add(questionData);
            }

            // Save the set into session for later validation
            session.setAttribute("questionsSet1", questionsSet1);
        } else {
            questionsSet1 = (ArrayList<String[]>) session.getAttribute("questionsSet1");
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }

    // Process answers if form submitted
    if (request.getParameter("submitSet1") != null) {
        questionsSet1 = (ArrayList<String[]>) session.getAttribute("questionsSet1");

        for (int i = 0; i < questionsSet1.size(); i++) {
            String userAnswer = request.getParameter("answer1_" + i);
            String correctAnswer = questionsSet1.get(i)[2];

            if (userAnswer == null || !userAnswer.equalsIgnoreCase(correctAnswer)) {
                isSet1Correct = false;
                break;
            }
        }

        // Clear stored questions after validation
        session.removeAttribute("questionsSet1");

        if (isSet1Correct) {
            response.sendRedirect("USER_HOME.jsp");
            return;
        } else {
            response.sendRedirect("USER_ANS2.jsp");
            return;
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
     <link rel="stylesheet" href="css/main.css">
     <link rel="stylesheet" href="css/form.css">
    <title>Security Check</title>
</head>
<body>
    <%
        String msg = (String) session.getAttribute("msg");
        if (msg != null) {
    %>
    <script>
        var ss = '<%=msg%>';
        alert(ss);
    </script>
    <%
            session.removeAttribute("msg");
        }
    %>

    <h2 class="header-title">Answer the Security Questions</h2>
    <div class="formbold-main-wrapper">
        <div class="formbold-form-wrapper">
            <form method="post" action="USER_ANS.jsp">
                <div class="formbold-mb-3">
                    <div>
                        <%
                            for (int i = 0; i < questionsSet1.size(); i++) {
                                String question = questionsSet1.get(i)[1];
                        %>
                        <label class="formbold-form-label"><%= question %></label>
                        <input type="text" name="answer1_<%= i %>" class="formbold-form-input" required />
                        <% } %>
                    </div>
                </div>
                <input type="submit" value="Submit Set 1" class="formbold-btn" name="submitSet1">
            </form>
        </div>
    </div>
</body>
</html>
